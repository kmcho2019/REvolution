module multi_pipe_4bit (
    input           clk,
    input           rst_n,
    input   [3:0]   mul_a,
    input   [3:0]   mul_b,
    output  [7:0]   mul_out
);

    // Define the size parameter
    parameter size = 4;

    // Declare internal signals
    wire    [7:0]   partial_product [3:0];
    reg     [7:0]   sum_reg1 [3:0];
    reg     [7:0]   sum_reg2;
    reg     [7:0]   product_reg;

    // Generate partial products
    genvar i;
    generate
        for (i = 0; i < size; i++) begin
            assign partial_product[i] = (mul_b[i] == 1'b1)? (mul_a << i) : 8'd0;
        end
    endgenerate

    // Store intermediate sum values in registers
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            sum_reg1[0] <= 8'd0;
        end else begin
            sum_reg1[0] <= partial_product[0];
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            sum_reg1[1] <= 8'd0;
        end else begin
            sum_reg1[1] <= partial_product[1] + (sum_reg1[0] >> 1);
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            sum_reg1[2] <= 8'd0;
        end else begin
            sum_reg1[2] <= partial_product[2] + (sum_reg1[1] >> 1);
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            sum_reg1[3] <= 8'd0;
        end else begin
            sum_reg1[3] <= partial_product[3] + (sum_reg1[2] >> 1);
        end
    end

    // Store sum of partial products in register
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            sum_reg2 <= 8'd0;
        end else begin
            sum_reg2 <= sum_reg1[3] + (sum_reg1[2] << 1) + (sum_reg1[1] << 2) + (sum_reg1[0] << 3);
        end
    end

    // Calculate final product
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            product_reg <= 8'd0;
        end else begin
            product_reg <= sum_reg2;
        end
    end

    // Assign product output
    assign mul_out = product_reg;

endmodule