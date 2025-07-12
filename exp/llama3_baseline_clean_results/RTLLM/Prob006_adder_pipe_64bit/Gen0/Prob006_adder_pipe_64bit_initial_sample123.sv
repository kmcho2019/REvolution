module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

// Define the registers for the pipeline stages
reg [63:0] reg_adda;
reg [63:0] reg_addb;
reg [63:0] reg_sum;
reg [64:0] reg_result;
reg i_en_reg;
reg o_en_reg;

// Define the carry signals for the ripple carry adder
reg [63:0] carry;

// Define the output enable signal
reg o_en_next;

// Synchronize the input enable signal with the clock and reset signals
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        i_en_reg <= 1'b0;
    end else begin
        i_en_reg <= i_en;
    end
end

// Store the input operands in the registers
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        reg_adda <= 64'd0;
        reg_addb <= 64'd0;
    end else if (i_en_reg) begin
        reg_adda <= adda;
        reg_addb <= addb;
    end
end

// Calculate the sum values for each pipeline stage
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        reg_sum <= 64'd0;
        carry <= 64'd0;
    end else if (i_en_reg) begin
        reg_sum <= reg_adda + reg_addb + {64{1'b0}};
        carry <= (reg_adda + reg_addb + {64{1'b0}}) >> 64;
    end
end

// Store the result in the register
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        reg_result <= 65'd0;
    end else if (i_en_reg) begin
        reg_result <= {carry, reg_sum};
    end
end

// Update the output enable signal
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        o_en_reg <= 1'b0;
        o_en_next <= 1'b0;
    end else begin
        o_en_next <= i_en_reg;
        o_en_reg <= o_en_next;
    end
end

// Assign the output signals
assign result = reg_result;
assign o_en = o_en_reg;

endmodule