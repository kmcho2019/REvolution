module multi_pipe_4bit(
    input clk, 
    input rst_n, 
    input [3:0] mul_a, 
    input [3:0] mul_b, 
    output [7:0] mul_out
);

    parameter size = 4;

    reg [7:0] reg1;
    reg [7:0] reg2;

    wire [7:0] partial_product [3:0];

    // Generate partial products
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin: partial_product_gen
            assign partial_product[i] = (mul_b[i] == 1'b1) ? (mul_a << i) : 8'd0;
        end
    endgenerate

    // First stage of addition
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            reg1 <= 8'd0;
        end else begin
            reg1 <= partial_product[0] + partial_product[1];
        end
    end

    // Second stage of addition
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            reg2 <= 8'd0;
        end else begin
            reg2 <= reg1 + partial_product[2] + partial_product[3];
        end
    end

    // Final product calculation
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            mul_out <= 8'd0;
        end else begin
            mul_out <= reg2;
        end
    end

endmodule