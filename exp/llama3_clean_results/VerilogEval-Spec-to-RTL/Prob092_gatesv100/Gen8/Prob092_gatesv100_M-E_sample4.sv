module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Define pipeline stages
    reg [99:0] stage1_both;
    reg [99:0] stage1_any;
    reg [99:0] stage1_different;
    reg [99:0] stage2_both;
    reg [99:0] stage2_any;
    reg [99:0] stage2_different;

    // Pipeline stage 1: Compute initial values
    always @(*) begin
        for (int i = 0; i < 100; i++) begin
            if (i < 99) begin
                stage1_both[i] = in[i] && in[i+1];
                stage1_any[i] = in[i] || in[i-1];
            end else begin
                stage1_both[i] = 0;
                stage1_any[i] = 0;
            end
            stage1_different[i] = in[i] ^ ((i == 99)? in[0] : in[i+1]);
        end
    end

    // Pipeline stage 2: Refine values based on neighbor conditions
    always @(*) begin
        for (int i = 0; i < 100; i++) begin
            if (i > 0) begin
                stage2_any[i] = stage1_any[i];
            end else begin
                stage2_any[i] = 0;
            end
            stage2_both[i] = stage1_both[i];
            stage2_different[i] = stage1_different[i];
        end
    end

    // Assign final outputs
    assign out_both = stage2_both;
    assign out_any = stage2_any;
    assign out_different = stage2_different;

endmodule