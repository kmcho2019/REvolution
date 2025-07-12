module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    // State registers (3 bits)
    reg [2:0] state;

    // Next state logic using decision tree
    always @(*) begin
        casez(state)
            3'b000: state = x ? 3'b001 : 3'b000;
            3'b001: state = x ? 3'b100 : 3'b001;
            3'b010: state = x ? 3'b001 : 3'b010;
            3'b011: state = x ? 3'b010 : 3'b001;
            3'b100: state = x ? 3'b100 : 3'b011;
            default: state = 3'b000;
        endcase
    end

    // State update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= 3'b000;
        else
            state <= state;
    end

    // Output is directly derived from state pattern
    assign z = (state[2] & ~state[1]) |  // State 100 (4)
               (state[2] & state[1]);    // State 011 (3)

endmodule