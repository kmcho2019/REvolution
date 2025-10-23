// TopModule: A simple Verilog module implementing a NOT gate using a lookup table approach.
module TopModule(
    input  in,  // Input signal to be inverted
    output reg out  // Output signal, inverted version of input
);

    // Implement the NOT gate using a lookup table approach inside an always block
    always @(*) begin
        case(in)
            1'b0: out = 1'b1;  // If input is 0, output is 1
            1'b1: out = 1'b0;  // If input is 1, output is 0
            default: out = 1'bx;  // For any other input, output is undefined
        endcase
    end

endmodule