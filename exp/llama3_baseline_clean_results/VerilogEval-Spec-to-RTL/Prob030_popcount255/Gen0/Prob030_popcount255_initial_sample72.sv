module TopModule(in, out);
    input [255:0] in;
    output [7:0] out;

    // Initialize the output to 0
    reg [7:0] out_reg;
    assign out = out_reg;

    // Count the number of '1's in the input vector
    always @(in) begin
        out_reg = 8'b0;
        for (int i = 0; i < 256; i++) begin
            if (in[i]) begin
                out_reg = out_reg + 1'b1;
            end
        end
    end
endmodule