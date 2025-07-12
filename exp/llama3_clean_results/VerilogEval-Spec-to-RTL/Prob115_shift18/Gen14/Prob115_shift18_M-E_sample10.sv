module TopModule(
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output [63:0] q
);

reg [63:0] q_reg;
reg [63:0] stage1_reg;
reg [63:0] stage2_reg;

// Stage 1: Load data or current value of q
always @(posedge clk) begin
    if (load) begin
        stage1_reg <= data;
    end else if (ena) begin
        stage1_reg <= q_reg;
    end else begin
        stage1_reg <= stage1_reg;
    end
end

// Stage 2: Determine shift direction and amount
wire shift_left;
wire shift_right;
wire [2:0] shift_amount;

assign shift_left = (amount == 2'b00 || amount == 2'b01);
assign shift_right = (amount == 2'b10 || amount == 2'b11);
assign shift_amount = (amount == 2'b00 || amount == 2'b10) ? 3'b001 : 3'b1000;

// Stage 3: Perform shift operation
always @(posedge clk) begin
    if (ena) begin
        if (shift_left) begin
            if (shift_amount == 3'b001) begin
                stage2_reg <= {stage1_reg[62:0], 1'b0};
            end else begin
                stage2_reg <= {stage1_reg[55:0], 8'd0};
            end
        end else if (shift_right) begin
            if (shift_amount == 3'b001) begin
                stage2_reg <= {stage1_reg[63], stage1_reg[63:1]};
            end else begin
                stage2_reg <= {{8{stage1_reg[63]}}, stage1_reg[63:8]};
            end
        end
    end else begin
        stage2_reg <= stage2_reg;
    end
end

// Stage 4: Update q_reg
always @(posedge clk) begin
    if (ena) begin
        q_reg <= stage2_reg;
    end else if (load) begin
        q_reg <= data;
    end else begin
        q_reg <= q_reg;
    end
end

assign q = q_reg;

endmodule