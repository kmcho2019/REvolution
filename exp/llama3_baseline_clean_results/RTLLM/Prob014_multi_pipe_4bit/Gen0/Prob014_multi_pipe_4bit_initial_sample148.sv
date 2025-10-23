module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

    parameter size = 4;

    // Extend input signals by adding "size" number of zero bits at the most significant bit positions
    wire [7:0] mul_a_ext;
    wire [7:0] mul_b_ext;

    // Registers to store intermediate sum values
    reg [7:0] reg1;
    reg [7:0] reg2;

    // Assign extended input signals
    assign mul_a_ext = {4'd0, mul_a};
    assign mul_b_ext = {4'd0, mul_b};

    // Generate block to perform multiplication for each bit position of the multiplier
    wire [7:0] partial_product [3:0];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin
            assign partial_product[i] = (mul_b[i] == 1'b1)? (mul_a_ext << i) : 8'd0;
        end
    endgenerate

    // Add partial products using registers
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            reg1 <= 8'd0;
        end else begin
            reg1 <= partial_product[0] + partial_product[1] + partial_product[2] + partial_product[3];
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            reg2 <= 8'd0;
        end else begin
            reg2 <= reg1;
        end
    end

    // Calculate final product
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            mul_out <= 8'd0;
        end else begin
            mul_out <= reg2;
        end
    end

endmodule