module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

parameter size = 4;

// Extend inputs with size zero bits at MSB as specified
wire [7:0] a_ext = {4'b0, mul_a};
wire [7:0] b_ext = {4'b0, mul_b};

// Stage 1: Partial product generation and initial sum
reg [7:0] partial_sum1;
reg [7:0] partial_sum2;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        partial_sum1 <= 8'b0;
        partial_sum2 <= 8'b0;
    end else begin
        // First two partial products
        partial_sum1 <= (b_ext[0] ? a_ext : 8'b0) + 
                       ((b_ext[1] ? a_ext : 8'b0) << 1);
        
        // Next two partial products
        partial_sum2 <= ((b_ext[2] ? a_ext : 8'b0) << 2) + 
                       ((b_ext[3] ? a_ext : 8'b0) << 3);
    end
end

// Stage 2: Final accumulation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 8'b0;
    end else begin
        mul_out <= partial_sum1 + partial_sum2;
    end
end

endmodule