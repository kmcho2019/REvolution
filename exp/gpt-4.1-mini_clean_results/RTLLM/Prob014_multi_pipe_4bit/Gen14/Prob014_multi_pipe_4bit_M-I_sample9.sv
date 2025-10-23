module multi_pipe_4bit #(
    parameter size = 4,
    parameter product_width = 2 * size
)(
    input                       clk,
    input                       rst_n,       // active low reset
    input      [size-1:0]       mul_a,
    input      [size-1:0]       mul_b,
    output reg [product_width-1:0] mul_out
);

    // Extend multiplicand with zeros on MSB side
    wire [product_width-1:0] mul_a_ext = {{size{1'b0}}, mul_a};

    // Stage 1: Generate partial products based on mul_b bits
    reg [product_width-1:0] pp [0:size-1];
    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < size; i = i + 1) begin
                pp[i] <= 0;
            end
        end else begin
            for (i = 0; i < size; i = i + 1) begin
                pp[i] <= mul_b[i] ? (mul_a_ext << i) : {product_width{1'b0}};
            end
        end
    end

    // Stage 2: Add partial products in pairs to reduce addition tree complexity
    // For 4 bits: sum0 = pp[0] + pp[1], sum1 = pp[2] + pp[3]
    reg [product_width-1:0] sum0, sum1;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum0 <= 0;
            sum1 <= 0;
        end else begin
            sum0 <= pp[0] + pp[1];
            sum1 <= pp[2] + pp[3];
        end
    end

    // Stage 3: Final addition of sum0 and sum1 to produce product output
    reg [product_width-1:0] final_sum;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            final_sum <= 0;
            mul_out <= 0;
        end else begin
            final_sum <= sum0 + sum1;
            mul_out <= final_sum;
        end
    end

endmodule