module TopModule (
    input clk,
    input in,
    output reg out
);

    // State machine approach
    always @(posedge clk) begin
        case(out)
            1'b0: out <= in;  // If current state is 0, next state is input
            1'b1: out <= ~in; // If current state is 1, next state is inverted input
        endcase
    end

endmodule