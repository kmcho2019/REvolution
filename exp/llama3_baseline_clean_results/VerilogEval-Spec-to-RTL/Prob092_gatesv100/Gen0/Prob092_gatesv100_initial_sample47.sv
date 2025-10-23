module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    integer i;

    always @(*) begin
        // Initialize all output bits to 0
        out_both = {100{1'b0}};
        out_any = {100{1'b0}};
        out_different = {100{1'b0}};

        // Iterate over each bit of the input vector
        for (i = 0; i < 100; i++) begin
            // Calculate out_both
            if (i < 99) begin
                out_both[i] = in[i] & in[i+1];
            end

            // Calculate out_any
            if (i > 0) begin
                out_any[i] = in[i] | in[i-1];
            end

            // Calculate out_different
            out_different[i] = in[i] ^ in[(i+1) % 100];
        end
    end

endmodule