module TopModule (
    input  clk,
    input  aresetn,  // active low asynchronous reset (negative edge)
    input  x,
    output reg z
);

    // State encoding: minimal 2-bit for 3 states
    localparam S0 = 2'b00; // no bits matched yet
    localparam S1 = 2'b01; // matched '1'
    localparam S2 = 2'b10; // matched "10"

    reg [1:0] state, next_state;

    // Next-state logic: combinational, default next_state to current state to avoid latches
    always @(*) begin
        next_state = state;
        if (state == S0) begin
            if (x)
                next_state = S1;
            else
                next_state = S0;
        end else if (state == S1) begin
            if (x)
                next_state = S1;
            else
                next_state = S2;
        end else /* state == S2 */ begin
            if (x)
                next_state = S1;
            else
                next_state = S0;
        end
    end

    // Mealy output logic: asserted combinationally on detection transition (state S2 and x=1)
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