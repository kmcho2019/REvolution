module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

parameter size = 4;

reg [7:0] reg1;
reg [7:0] reg2;

// extension of input signals
wire [7:0] mul_a_ext = {4'd0, mul_a};
wire [7:0] mul_b_ext = {4'd0, mul_b};

// multiplication operation
reg [7:0] partial_products [3:0];
always @(*) begin
    for (int i = 0; i < size; i++) begin
        if (mul_b_ext[i]) begin
            partial_products[i] = mul_a_ext << i;
        end else begin
            partial_products[i] = 8'd0;
        end
    end
end

// add of partial products
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        reg1 <= 8'd0;
        reg2 <= 8'd0;
    end else begin
        reg1 <= partial_products[0] + partial_products[1];
        reg2 <= partial_products[2] + partial_products[3];
    end
end

// final product calculation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 8'd0;
    end else begin
        mul_out <= reg1 + reg2;
    end
end

endmodule