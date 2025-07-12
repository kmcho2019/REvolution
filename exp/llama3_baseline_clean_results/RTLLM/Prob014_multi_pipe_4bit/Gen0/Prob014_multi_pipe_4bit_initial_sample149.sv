module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

// Extended input signals
reg [7:0] ext_mul_a;
reg [7:0] ext_mul_b;

// Intermediate sum registers
reg [7:0] reg1;
reg [7:0] reg2;

// Partial product generation
always @(*) begin
    ext_mul_a = {4'd0, mul_a};
    ext_mul_b = {4'd0, mul_b};
end

// Register update
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg1 <= 8'd0;
        reg2 <= 8'd0;
        mul_out <= 8'd0;
    end else begin
        reg1 <= ext_mul_a;
        for (int i = 1; i < 4; i++) begin
            if (ext_mul_b[i]) begin
                reg1 <= reg1 + (ext_mul_a << i);
            end
        end
        reg2 <= reg1;
        mul_out <= reg2;
    end
end

endmodule