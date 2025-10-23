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
wire [2*size-1:0] mul_a_ext;
assign mul_a_ext = { {size{1'b0}}, mul_a };

// Partial products
wire [2*size-1:0] partial_products [size-1:0];

// Generate partial products
genvar i;
generate
    for (i = 0; i < size; i++) begin
        assign partial_products[i] = (mul_b[i] == 1'b1)? (mul_a_ext << i) : {2*size{1'b0}};
    end
endgenerate

// Pipeline registers
reg [2*size-1:0] reg1 [size-1:0];
reg [2*size-1:0] reg2;

// Add partial products
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (int i = 0; i < size; i++) begin
            reg1[i] <= {2*size{1'b0}};
        end
        reg2 <= {2*size{1'b0}};
    end else begin
        for (int i = 0; i < size; i++) begin
            if (i == 0) begin
                reg1[i] <= partial_products[i];
            end else begin
                reg1[i] <= reg1[i-1] + partial_products[i];
            end
        end
        reg2 <= reg1[size-1];
    end
end

// Final product calculation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out <= {2*size{1'b0}};
    end else begin
        mul_out <= reg2;
    end
end

endmodule