module TopModule(in, out);
    input [255:0] in;
    output [7:0] out;

    // Initialize count
    reg [7:0] count;

    // Count the number of '1's in the input vector
    always @(in) begin
        count = 0;
        for (int i = 0; i < 256; i++) begin
            if (in[i])
                count = count + 1;
        end
        out = count;
    end
endmodule