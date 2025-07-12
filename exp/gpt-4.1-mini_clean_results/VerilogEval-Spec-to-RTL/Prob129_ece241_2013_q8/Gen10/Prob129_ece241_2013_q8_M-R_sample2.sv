module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    localparam S0 = 2'b00; // no bits matched
    localparam S1 = 2'b01; // matched '1'
    localparam S2 = 2'b10; // matched '10'

    reg [1:0] state;
    wire [1:0] next_state;

    // Next state logic using continuous assignment
    assign next_state = (state == S0) ? (x ? S1 : S0) :
                        (state == S1) ? (x ? S1 : S2) :
                        (state == S2) ? (x ? S1 : S0) :
                        S0;

    // Output logic using continuous assignment before reg update
    // z is Mealy output: asserted when in S2 and x == 1
    // but z is reg, so update in always block
    always @(*) begin
        z = ((state == S2) && x) ? 1'b1 : 1'b0;
    end

    // State register with asynchronous negative edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

endmodule