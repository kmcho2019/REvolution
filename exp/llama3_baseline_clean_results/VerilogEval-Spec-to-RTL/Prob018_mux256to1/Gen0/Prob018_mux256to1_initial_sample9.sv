module TopModule(
    input  [255:0] in,
    input  [7:0] sel,
    output out
);

    always @(in, sel) begin
        case (sel)
            256'd0: out = in[0];
            256'd1: out = in[1];
            256'd2: out = in[2];
            //...
            // This approach is impractical for a large number of cases.
            // A more practical approach is to use a for loop to generate the cases.
            // However, Verilog does not directly support this.

            // Instead, we can use a continuous assignment to select the bit.
            // We can do this by shifting the input vector to the right by the value of sel
            // multiplied by the width of each input (which is 1 in this case), and then
            // selecting the least significant bit.
            default: out = in[sel];
        endcase
    end

endmodule