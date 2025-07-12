module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Pipeline registers
    reg [15:0] pp0, pp1, pp2, pp3;  // Partial products
    reg [15:0] stage1_out0, stage1_out1;
    reg [15:0] stage2_out;
    reg stage1_valid, stage2_valid;

    // Sign-extended multiplicand
    wire [15:0] multiplicand = {{8{a[7]}}, a};

    // Booth encoders (parallel)
    wire [1:0] booth_enc0 = {b[1], b[0], 1'b0};
    wire [1:0] booth_enc1 = {b[3], b[2], b[1]};
    wire [1:0] booth_enc2 = {b[5], b[4], b[3]};
    wire [1:0] booth_enc3 = {b[7], b[6], b[5]};

    // Partial product generators (combinational)
    always @(*) begin
        // PP0
        case (booth_enc0)
            3'b000, 3'b111: pp0 = 16'b0;
            3'b001, 3'b010: pp0 = multiplicand;
            3'b011: pp0 = multiplicand << 1;
            3'b100: pp0 = -(multiplicand << 1);
            3'b101, 3'b110: pp0 = -multiplicand;
        endcase

        // PP1 (shifted left by 2)
        case (booth_enc1)
            3'b000, 3'b111: pp1 = 16'b0;
            3'b001, 3'b010: pp1 = multiplicand << 2;
            3'b011: pp1 = multiplicand << 3;
            3'b100: pp1 = -(multiplicand << 3);
            3'b101, 3'b110: pp1 = -(multiplicand << 2);
        endcase

        // PP2 (shifted left by 4)
        case (booth_enc2)
            3'b000, 3'b111: pp2 = 16'b0;
            3'b001, 3'b010: pp2 = multiplicand << 4;
            3'b011: pp2 = multiplicand << 5;
            3'b100: pp2 = -(multiplicand << 5);
            3'b101, 3'b110: pp2 = -(multiplicand << 4);
        endcase

        // PP3 (shifted left by 6)
        case (booth_enc3)
            3'b000, 3'b111: pp3 = 16'b0;
            3'b001, 3'b010: pp3 = multiplicand << 6;
            3'b011: pp3 = multiplicand << 7;
            3'b100: pp3 = -(multiplicand << 7);
            3'b101, 3'b110: pp3 = -(multiplicand << 6);
        endcase
    end

    // Pipeline stage 1: Wallace tree first level (3:2 compressors)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stage1_out0 <= 16'b0;
            stage1_out1 <= 16'b0;
            stage1_valid <= 1'b0;
        end else begin
            // First level compression (PP0 + PP1 + PP2)
            {stage1_out1[0], stage1_out0[0]} = pp0[0] + pp1[0] + pp2[0];
            {stage1_out1[1], stage1_out0[1]} = pp0[1] + pp1[1] + pp2[1];
            // ... repeat for all 16 bits ...
            {stage1_out1[15], stage1_out0[15]} = pp0[15] + pp1[15] + pp2[15];
            
            stage1_valid <= 1'b1;
        end
    end

    // Pipeline stage 2: Final addition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            p <= 16'b0;
            rdy <= 1'b0;
            stage2_valid <= 1'b0;
        end else begin
            if (stage1_valid) begin
                // Add compressed results with PP3
                stage2_out <= stage1_out0 + stage1_out1 + pp3;
                stage2_valid <= 1'b1;
            end
            
            if (stage2_valid) begin
                p <= stage2_out;
                rdy <= 1'b1;
            end else begin
                rdy <= 1'b0;
            end
        end
    end

endmodule