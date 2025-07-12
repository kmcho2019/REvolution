module TopModule(
    input  logic [4:0] a,
    input  logic [4:0] b,
    input  logic [4:0] c,
    input  logic [4:0] d,
    input  logic [4:0] e,
    input  logic [4:0] f,
    output logic [7:0] w,
    output logic [7:0] x,
    output logic [7:0] y,
    output logic [7:0] z
);

    logic [9:0] stage1_out;
    logic [14:0] stage2_out;
    logic [19:0] stage3_out;
    logic [24:0] stage4_out;
    logic [29:0] stage5_out;
    logic [31:0] stage6_out;

    // Stage 1: Concatenate a and b
    always_ff @(posedge clk) begin
        stage1_out <= {a, b};
    end

    // Stage 2: Concatenate stage1_out and c
    always_ff @(posedge clk) begin
        stage2_out <= {stage1_out, c};
    end

    // Stage 3: Concatenate stage2_out and d
    always_ff @(posedge clk) begin
        stage3_out <= {stage2_out, d};
    end

    // Stage 4: Concatenate stage3_out and e
    always_ff @(posedge clk) begin
        stage4_out <= {stage3_out, e};
    end

    // Stage 5: Concatenate stage4_out and f
    always_ff @(posedge clk) begin
        stage5_out <= {stage4_out, f};
    end

    // Stage 6: Append two 1 bits to stage5_out
    always_ff @(posedge clk) begin
        stage6_out <= {stage5_out, 2'b11};
    end

    // Output stage: Split stage6_out into w, x, y, and z
    always_comb begin
        w = stage6_out[31:24];
        x = stage6_out[23:16];
        y = stage6_out[15:8];
        z = stage6_out[7:0];
    end

endmodule