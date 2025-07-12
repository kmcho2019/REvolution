module adder_pipe_64bit(
    input             clk,
    input             rst_n,
    input             i_en,
    input      [63:0] adda,
    input      [63:0] addb,
    output reg [64:0] result,
    output reg         o_en
);

reg [63:0] reg_adda;
reg [63:0] reg_addb;
reg        reg_i_en;
reg [63:0] sum [3:0];
reg        carry [3:0];
reg [64:0] reg_result;

// Stage 1: Input registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        reg_adda <= 64'd0;
        reg_addb <= 64'd0;
        reg_i_en <= 1'b0;
    end else if (i_en) begin
        reg_adda <= adda;
        reg_addb <= addb;
        reg_i_en <= 1'b1;
    end else begin
        reg_adda <= reg_adda;
        reg_addb <= reg_addb;
        reg_i_en <= reg_i_en;
    end
end

// Stage 2: Ripple carry adder
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (int i = 0; i < 4; i++) begin
            sum[i] <= 64'd0;
            carry[i] <= 1'b0;
        end
    end else begin
        for (int i = 0; i < 4; i++) begin
            if (i == 0) begin
                sum[i] <= reg_adda[15:0] + reg_addb[15:0];
                carry[i] <= (reg_adda[15:0] + reg_addb[15:0]) > 16'd65535;
            end else if (i == 1) begin
                sum[i] <= reg_adda[31:16] + reg_addb[31:16] + carry[i-1];
                carry[i] <= (reg_adda[31:16] + reg_addb[31:16] + carry[i-1]) > 16'd65535;
            end else if (i == 2) begin
                sum[i] <= reg_adda[47:32] + reg_addb[47:32] + carry[i-1];
                carry[i] <= (reg_adda[47:32] + reg_addb[47:32] + carry[i-1]) > 16'd65535;
            end else if (i == 3) begin
                sum[i] <= reg_adda[63:48] + reg_addb[63:48] + carry[i-1];
                carry[i] <= (reg_adda[63:48] + reg_addb[63:48] + carry[i-1]) > 16'd65535;
            end
        end
    end
end

// Stage 3: Output registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        reg_result <= 65'd0;
        o_en <= 1'b0;
    end else if (reg_i_en) begin
        reg_result <= {carry[3], sum[3], sum[2], sum[1], sum[0]};
        o_en <= 1'b1;
    end else begin
        reg_result <= reg_result;
        o_en <= 1'b0;
    end
end

// Output assignment
assign result = reg_result;

endmodule