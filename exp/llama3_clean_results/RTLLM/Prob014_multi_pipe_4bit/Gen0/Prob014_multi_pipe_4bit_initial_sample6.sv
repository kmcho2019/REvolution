module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output [2*size-1:0] mul_out
);

// Extended input signals
reg [2*size-1:0] extended_a;
reg [size-1:0] extended_b;

// Intermediate registers
reg [2*size-1:0] reg1;
reg [2*size-1:0] reg2;

// Final product register
reg [2*size-1:0] product;

// Generate block for multiplication
genvar i;
generate
    for (i = 0; i < size; i++) begin
        if (mul_b[i]) begin
            assign extended_a[2*size-1-i-1 -: size] = mul_a << i;
        end else begin
            assign extended_a[2*size-1-i-1 -: size] = 'd0;
        end
    end
endgenerate

// Pipeline registers
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg1 <= 'd0;
        reg2 <= 'd0;
        product <= 'd0;
    end else begin
        reg1 <= extended_a;
        reg2 <= reg1;
        product <= reg2;
    end
end

// Final product calculation
assign mul_out = product;

endmodule