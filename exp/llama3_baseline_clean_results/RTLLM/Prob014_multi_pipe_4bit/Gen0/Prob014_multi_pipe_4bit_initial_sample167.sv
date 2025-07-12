module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

    reg [7:0] partial_product [3:0];
    reg [7:0] reg1 [3:0];
    reg [7:0] reg2;

    // Extend the input signals
    wire [7:0] mul_a_ext = {4'd0, mul_a};
    wire [7:0] mul_b_ext = {4'd0, mul_b};

    // Generate partial products
    genvar i;
    generate
        for (i = 0; i < 4; i++) begin
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    partial_product[i] <= 8'd0;
                end else if (mul_b_ext[i] == 1'b1) begin
                    partial_product[i] <= mul_a_ext << i;
                end else begin
                    partial_product[i] <= 8'd0;
                end
            end
        end
    endgenerate

    // First level of registers to store intermediate sum values
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg1 <= '{default: 8'd0};
        end else begin
            reg1[0] <= partial_product[0];
            reg1[1] <= partial_product[1];
            reg1[2] <= partial_product[2];
            reg1[3] <= partial_product[3];
        end
    end

    // Second level of registers to store intermediate sum values
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg2 <= 8'd0;
        end else begin
            reg2 <= reg1[0] + reg1[1] + reg1[2] + reg1[3];
        end
    end

    // Calculate final product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 8'd0;
        end else begin
            mul_out <= reg2;
        end
    end

endmodule