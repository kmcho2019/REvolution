module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output [7:0] mul_out
);

parameter size = 4;

// extend input signals
wire [7:0] mul_a_ext = {4'd0, mul_a};
wire [7:0] mul_b_ext = {4'd0, mul_b};

// intermediate registers
reg [7:0] reg1;
reg [7:0] reg2;

// initialize registers
initial begin
    reg1 = 8'd0;
    reg2 = 8'd0;
end

// generate partial products
genvar i;
generate
    for (i = 0; i < size; i++) begin : partial_product_gen
        wire [7:0] partial_product;
        assign partial_product = (mul_b_ext[i] == 1'b1) ? (mul_a_ext << i) : 8'd0;

        // add partial products to reg1
        if (i == 0) begin
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    reg1 <= 8'd0;
                end else begin
                    reg1 <= partial_product;
                end
            end
        end else begin
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    reg1 <= 8'd0;
                end else begin
                    reg1 <= reg1 + partial_product;
                end
            end
        end
    end
endgenerate

// add reg1 to reg2
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        reg2 <= 8'd0;
    end else begin
        reg2 <= reg1;
    end
end

// calculate final product
assign mul_out = (rst_n == 1'b0) ? 8'd0 : reg2;

endmodule