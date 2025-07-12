module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Shifter module
module shifter(
    input [size-1:0] a,
    input [size-1:0] shift,
    output reg [2*size-1:0] out
);
    always @(*) begin
        if (shift == 0) begin
            out = {size{1'b0}} + a;
        end else begin
            out = {size{1'b0}} + (a << shift);
        end
    end
endmodule

// Adder module
module adder(
    input [2*size-1:0] a,
    input [2*size-1:0] b,
    output reg [2*size-1:0] out
);
    always @(*) begin
        out = a + b;
    end
endmodule

// Pipeline module
module pipeline(
    input clk,
    input rst_n,
    input [2*size-1:0] in,
    output reg [2*size-1:0] out1,
    output reg [2*size-1:0] out2
);
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            out1 <= {2*size{1'b0}};
            out2 <= {2*size{1'b0}};
        end else begin
            out1 <= in;
            out2 <= out1;
        end
    end
endmodule

// Instantiations
wire [2*size-1:0] partial_product [size];
wire [2*size-1:0] sum [size];
reg [2*size-1:0] intermediate_sum;
reg [2*size-1:0] final_sum;

// Generate partial products
genvar i;
generate
    for (i = 0; i < size; i = i + 1) begin
        shifter shifter_i (
            .a(mul_a),
            .shift(i),
            .out(partial_product[i])
        );
        
        if (i == 0) begin
            assign sum[i] = (mul_b[i] == 1'b1) ? partial_product[i] : {2*size{1'b0}};
        end else begin
            adder adder_i (
                .a(sum[i-1]),
                .b((mul_b[i] == 1'b1) ? partial_product[i] : {2*size{1'b0}},
                .out(sum[i])
            );
        end
    end
endgenerate

// Final sum calculation
assign intermediate_sum = sum[size-1];

// Pipeline
pipeline pipeline_i (
    .clk(clk),
    .rst_n(rst_n),
    .in(intermediate_sum),
    .out1(final_sum),
    .out2(mul_out)
);

endmodule