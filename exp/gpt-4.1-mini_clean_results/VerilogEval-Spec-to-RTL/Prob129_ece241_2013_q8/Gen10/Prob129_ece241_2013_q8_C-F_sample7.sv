module TopModule (
    input  clk,
    input  aresetn,  // active low asynchronous reset (negative edge)
    input  x,
    output reg z
);

    // State encoding: 3 states for sequence "101" detection
    localparam S0 = 2'b00; // no bits matched yet
    localparam S1 = 2'b01; // matched '1'
    localparam S2 = 2'b10; // matched "10"

    reg [1:0] state, next_state;

    // Next-state logic: combinational with default assignment to prevent latches
    always @(*) begin
        next_state = state;
        if (state == S0) begin
            next_state = x ? S1 : S0;
        end else if (state == S1) begin
            next_state = x ? S1 : S2;
        end else /* state == S2 */ begin
            next_state = x ? S1 : S0;
        end
    end

    // Mealy output logic: z asserted when detecting sequence "101" at input x=1 in state S2
    always @(*) begin
        z = (state == S2) && x;
    end

    // State register with asynchronous negative-edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

endmodule