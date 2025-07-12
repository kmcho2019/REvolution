module adder_pipe_64bit(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  [64:0]  result,
    output          o_en
);

// Internal registers to hold input operands
reg [63:0] reg_adda;
reg [63:0] reg_addb;

// Internal register to hold the result
reg [64:0] reg_result;

// Internal register to hold the output enable signal
reg reg_o_en;

// State variable to track the result availability
reg reg_result_avail;

// Assign outputs
assign result = reg_result;
assign o_en = reg_o_en;

// Reset logic
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_adda <= 64'd0;
        reg_addb <= 64'd0;
        reg_result <= 65'd0;
        reg_o_en <= 1'b0;
        reg_result_avail <= 1'b0;
    end
end

// Capture input operands and set output enable
always @ (posedge clk) begin
    if (i_en) begin
        reg_adda <= adda;
        reg_addb <= addb;
        reg_result_avail <= 1'b1;
    end else begin
        reg_result_avail <= 1'b0;
    end
end

// Calculate the result
always @ (posedge clk) begin
    if (reg_result_avail) begin
        reg_result <= {1'b0, reg_adda} + {1'b0, reg_addb};
        reg_o_en <= 1'b1;
    end else begin
        reg_o_en <= 1'b0;
    end
end

endmodule