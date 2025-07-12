module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

reg [63:0] reg_adda;
reg [63:0] reg_addb;
reg reg_i_en;
reg [63:0] sum;
reg [63:0] carry;

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        reg_adda <= 64'd0;
        reg_addb <= 64'd0;
        reg_i_en <= 1'd0;
        sum <= 64'd0;
        carry <= 64'd0;
        result <= 65'd0;
        o_en <= 1'd0;
    end else begin
        // Stage 1: Input register stage
        if (i_en) begin
            reg_adda <= adda;
            reg_addb <= addb;
            reg_i_en <= 1'd1;
        end else begin
            reg_i_en <= 1'd0;
        end

        // Stage 2: Ripple carry adder stage
        if (reg_i_en) begin
            sum <= reg_adda + reg_addb;
            carry <= (reg_adda[0] + reg_addb[0]);
            for (int i = 1; i < 64; i++) begin
                sum[i] <= reg_adda[i] + reg_addb[i] + carry[i-1];
                carry[i] <= (reg_adda[i] + reg_addb[i] + carry[i-1]) > 63? 1'd1 : 1'd0;
            end
        end

        // Stage 3: Output register stage
        if (reg_i_en) begin
            result <= {1'd0, sum};
            o_en <= 1'd1;
        end else begin
            o_en <= 1'd0;
        end
    end
end

endmodule