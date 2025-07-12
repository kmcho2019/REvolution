module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Initialize all output bits to 0
    integer i;
    always @(*) begin
        for (i = 0; i < 100; i++) begin
            out_both[i] = 0;
            out_any[i] = 0;
            out_different[i] = 0;
        end

        // Calculate out_both
        for (i = 0; i < 99; i++) begin
            if (in[i] == 1 && in[i+1] == 1) begin
                out_both[i] = 1;
            end
        end

        // Calculate out_any
        for (i = 1; i < 100; i++) begin
            if (in[i] == 1 || in[i-1] == 1) begin
                out_any[i] = 1;
            end
        end

        // Calculate out_different
        for (i = 0; i < 100; i++) begin
            if (in[i] != in[(i+1)%100]) begin
                out_different[i] = 1;
            end
        end
    end

endmodule