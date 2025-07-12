module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

    // Extended input signals with zeros at MSB positions
    wire [7:0] ext_mul_a = {4'd0, mul_a};
    wire [7:0] ext_mul_b = {4'd0, mul_b};

    // Partial products
    wire [7:0] partial_product [3:0];

    // Intermediate sum values
    reg [7:0] sum1 = 8'd0;
    reg [7:0] sum2 = 8'd0;

    // Generate block for partial product calculation
    genvar i;
    generate
        for(i = 0; i < 4; i = i + 1) begin
            if(i == 0) begin
                assign partial_product[i] = (ext_mul_b[i]) ? ext_mul_a : 8'd0;
            end else begin
                assign partial_product[i] = (ext_mul_b[i]) ? (ext_mul_a << i) : 8'd0;
            end
        end
    endgenerate

    // Update sum1 on positive edge of clk or falling edge of rst_n
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            sum1 <= 8'd0;
        end else begin
            sum1 <= partial_product[0] + partial_product[1];
        end
    end

    // Update sum2 on positive edge of clk or falling edge of rst_n
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            sum2 <= 8'd0;
        end else begin
            sum2 <= sum1 + partial_product[2] + partial_product[3];
        end
    end

    // Update mul_out on positive edge of clk or falling edge of rst_n
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            mul_out <= 8'd0;
        end else begin
            mul_out <= sum2;
        end
    end

endmodule