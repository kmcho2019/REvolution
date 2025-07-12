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
reg [2*size-1:0] extended_b;

// Intermediate sum values
reg [2*size-1:0] sum1;
reg [2*size-1:0] sum2;

// Final product
reg [2*size-1:0] product;

// Extend input signals
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        extended_a <= 0;
        extended_b <= 0;
    end else begin
        extended_a <= {mul_a, {size{1'b0}}};
        extended_b <= {mul_b, {size{1'b0}}};
    end
end

// Generate partial products and add them
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum1 <= 0;
    end else begin
        reg [2*size-1:0] partial_product;
        partial_product = 0;
        for (int i = 0; i < size; i++) begin
            if (extended_b[i]) begin
                partial_product = partial_product + (extended_a << i);
            end
        end
        sum1 <= partial_product;
    end
end

// Store intermediate sum value
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum2 <= 0;
    end else begin
        sum2 <= sum1;
    end
end

// Calculate final product
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        product <= 0;
    end else begin
        product <= sum2;
    end
end

// Assign final product to output
assign mul_out = product;

endmodule