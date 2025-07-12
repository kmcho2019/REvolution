module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output [7:0] mul_out
);

    // Extended input signals
    wire [7:0] mul_a_ext;
    assign mul_a_ext = {4'd0, mul_a};

    wire [7:0] mul_b_ext;
    assign mul_b_ext = {4'd0, mul_b};

    // Intermediate registers
    reg [7:0] reg1;
    reg [7:0] reg2;

    // Initialize registers
    initial begin
        reg1 = 8'd0;
        reg2 = 8'd0;
    end

    // Perform multiplication and addition
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            reg1 <= 8'd0;
            reg2 <= 8'd0;
        end else begin
            // Generate partial products
            wire [7:0] partial_product [3:0];
            genvar i;
            generate
                for (i = 0; i < 4; i = i + 1) begin
                    assign partial_product[i] = (mul_b_ext[i])? (mul_a_ext << i) : 8'd0;
                end
            endgenerate

            // Add partial products
            reg1 <= partial_product[0] + partial_product[1];
            reg2 <= partial_product[2] + partial_product[3];
        end
    end

    // Calculate final product
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            mul_out <= 8'd0;
        end else begin
            mul_out <= reg1 + reg2;
        end
    end

endmodule