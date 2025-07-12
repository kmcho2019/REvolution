module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output wire [64:0] result,
    output wire o_en
);

// Pipeline registers
reg [63:0] a_reg, b_reg;
reg en_reg;
reg [64:0] sum_reg;

// Combinational adder logic
wire [64:0] sum_next = {1'b0, a_reg} + {1'b0, b_reg};

// Output assignments
assign result = sum_reg;
assign o_en = en_reg;

// Input stage pipeline registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_reg <= 64'b0;
        b_reg <= 64'b0;
    end else begin
        a_reg <= adda;
        b_reg <= addb;
    end
end

// Enable signal pipeline
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        en_reg <= 1'b0;
    end else begin
        en_reg <= i_en;
    end
end

// Output stage pipeline register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_reg <= 65'b0;
    end else begin
        sum_reg <= sum_next;
    end
end

endmodule