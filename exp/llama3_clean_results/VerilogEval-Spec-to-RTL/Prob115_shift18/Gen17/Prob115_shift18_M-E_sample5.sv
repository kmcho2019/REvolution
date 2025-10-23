module TopModule(
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output [63:0] q
);

reg [63:0] q_reg;

// Control unit to determine shift operation
wire [1:0] shift_amount;
wire shift_left;
wire shift_right;
assign shift_amount = amount;
assign shift_left = (amount == 2'b00 || amount == 2'b01);
assign shift_right = (amount == 2'b10 || amount == 2'b11);

// Pipeline-based shift logic
reg [7:0] stage0 [7:0];
reg [7:0] stage1 [7:0];
reg [7:0] stage2 [7:0];
reg [7:0] stage3 [7:0];
reg [7:0] stage4 [7:0];
reg [7:0] stage5 [7:0];
reg [7:0] stage6 [7:0];
reg [7:0] stage7 [7:0];

// Initial stage
always @(posedge clk) begin
    if (load) begin
        for (int i = 0; i < 8; i++) begin
            stage0[i] <= data[(i*8)+:8];
        end
    end else if (ena) begin
        if (shift_left) begin
            if (shift_amount == 2'b00) begin
                for (int i = 0; i < 8; i++) begin
                    stage0[i] <= {stage0[i][6:0], 1'b0};
                end
            end else if (shift_amount == 2'b01) begin
                for (int i = 0; i < 8; i++) begin
                    stage0[i] <= (i < 7) ? stage0[i+1] : 8'd0;
                end
            end
        end else if (shift_right) begin
            if (shift_amount == 2'b10) begin
                for (int i = 0; i < 8; i++) begin
                    stage0[i] <= {stage0[i][7], stage0[i][7:1]};
                end
            end else if (shift_amount == 2'b11) begin
                for (int i = 0; i < 8; i++) begin
                    stage0[i] <= (i > 0) ? stage0[i-1] : {8{stage0[0][7]}};
                end
            end
        end
    end
end

// Pipeline stages
always @(posedge clk) begin
    if (ena) begin
        stage1 <= stage0;
        stage2 <= stage1;
        stage3 <= stage2;
        stage4 <= stage3;
        stage5 <= stage4;
        stage6 <= stage5;
        stage7 <= stage6;
    end
end

// Final stage
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else if (ena) begin
        for (int i = 0; i < 8; i++) begin
            q_reg[(i*8)+:8] <= stage7[i];
        end
    end
end

assign q = q_reg;

endmodule