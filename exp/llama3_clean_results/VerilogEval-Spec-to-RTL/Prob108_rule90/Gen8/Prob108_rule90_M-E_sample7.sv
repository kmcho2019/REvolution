module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;

// Pipeline stages
wire [63:0] stage1_out;
wire [63:0] stage2_out;
wire [63:0] stage3_out;
wire [63:0] stage4_out;
wire [63:0] stage5_out;
wire [63:0] stage6_out;
wire [63:0] stage7_out;
wire [63:0] stage8_out;

// Stage 1: Calculate next state for cells 0-63
always @(posedge clk) begin
    if (load) begin
        stage1_out <= data[63:0];
    end else begin
        for (int i = 0; i < 64; i++) begin
            if (i == 0) begin
                stage1_out[i] <= q_reg[1];
            end else if (i == 63) begin
                stage1_out[i] <= q_reg[62];
            end else begin
                stage1_out[i] <= q_reg[i-1] ^ q_reg[i+1];
            end
        end
    end
end

// Stage 2: Calculate next state for cells 64-127
always @(posedge clk) begin
    if (load) begin
        stage2_out <= data[127:64];
    end else begin
        for (int i = 64; i < 128; i++) begin
            if (i == 64) begin
                stage2_out[i-64] <= q_reg[65];
            end else if (i == 127) begin
                stage2_out[i-64] <= q_reg[126];
            end else begin
                stage2_out[i-64] <= q_reg[i-1] ^ q_reg[i+1];
            end
        end
    end
end

// Stage 3: Calculate next state for cells 128-191
always @(posedge clk) begin
    if (load) begin
        stage3_out <= data[191:128];
    end else begin
        for (int i = 128; i < 192; i++) begin
            if (i == 128) begin
                stage3_out[i-128] <= q_reg[129];
            end else if (i == 191) begin
                stage3_out[i-128] <= q_reg[190];
            end else begin
                stage3_out[i-128] <= q_reg[i-1] ^ q_reg[i+1];
            end
        end
    end
end

// Stage 4: Calculate next state for cells 192-255
always @(posedge clk) begin
    if (load) begin
        stage4_out <= data[255:192];
    end else begin
        for (int i = 192; i < 256; i++) begin
            if (i == 192) begin
                stage4_out[i-192] <= q_reg[193];
            end else if (i == 255) begin
                stage4_out[i-192] <= q_reg[254];
            end else begin
                stage4_out[i-192] <= q_reg[i-1] ^ q_reg[i+1];
            end
        end
    end
end

// Stage 5: Calculate next state for cells 256-319
always @(posedge clk) begin
    if (load) begin
        stage5_out <= data[319:256];
    end else begin
        for (int i = 256; i < 320; i++) begin
            if (i == 256) begin
                stage5_out[i-256] <= q_reg[257];
            end else if (i == 319) begin
                stage5_out[i-256] <= q_reg[318];
            end else begin
                stage5_out[i-256] <= q_reg[i-1] ^ q_reg[i+1];
            end
        end
    end
end

// Stage 6: Calculate next state for cells 320-383
always @(posedge clk) begin
    if (load) begin
        stage6_out <= data[383:320];
    end else begin
        for (int i = 320; i < 384; i++) begin
            if (i == 320) begin
                stage6_out[i-320] <= q_reg[321];
            end else if (i == 383) begin
                stage6_out[i-320] <= q_reg[382];
            end else begin
                stage6_out[i-320] <= q_reg[i-1] ^ q_reg[i+1];
            end
        end
    end
end

// Stage 7: Calculate next state for cells 384-447
always @(posedge clk) begin
    if (load) begin
        stage7_out <= data[447:384];
    end else begin
        for (int i = 384; i < 448; i++) begin
            if (i == 384) begin
                stage7_out[i-384] <= q_reg[385];
            end else if (i == 447) begin
                stage7_out[i-384] <= q_reg[446];
            end else begin
                stage7_out[i-384] <= q_reg[i-1] ^ q_reg[i+1];
            end
        end
    end
end

// Stage 8: Calculate next state for cells 448-511
always @(posedge clk) begin
    if (load) begin
        stage8_out <= data[511:448];
    end else begin
        for (int i = 448; i < 512; i++) begin
            if (i == 448) begin
                stage8_out[i-448] <= q_reg[449];
            end else if (i == 511) begin
                stage8_out[i-448] <= q_reg[510];
            end else begin
                stage8_out[i-448] <= q_reg[i-1] ^ q_reg[i+1];
            end
        end
    end
end

// Update state registers
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        q_reg[63:0] <= stage1_out;
        q_reg[127:64] <= stage2_out;
        q_reg[191:128] <= stage3_out;
        q_reg[255:192] <= stage4_out;
        q_reg[319:256] <= stage5_out;
        q_reg[383:320] <= stage6_out;
        q_reg[447:384] <= stage7_out;
        q_reg[511:448] <= stage8_out;
    end
end

assign q = q_reg;

endmodule