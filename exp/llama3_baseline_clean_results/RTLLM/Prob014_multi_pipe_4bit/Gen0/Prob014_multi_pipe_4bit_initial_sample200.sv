module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output [2*size-1:0] mul_out
);

// Extended input signals with zero bits
wire [2*size-1:0] ext_a;
assign ext_a = { {size{1'b0}}, mul_a };

// Generate block to perform multiplication for each bit position of the multiplier
reg [2*size-1:0] pp [size-1:0];
reg [2*size-1:0] sum1;
reg [2*size-1:0] sum2;

integer i;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (i = 0; i < size; i++) begin
            pp[i] <= 0;
        end
        sum1 <= 0;
        sum2 <= 0;
    end else begin
        for (i = 0; i < size; i++) begin
            if (mul_b[i]) begin
                pp[i] <= ext_a << i;
            end else begin
                pp[i] <= 0;
            end
        end
        sum1 <= pp[0] + pp[1];
        sum2 <= pp[2] + pp[3];
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out <= 0;
    end else begin
        mul_out <= sum1 + sum2;
    end
end

endmodule