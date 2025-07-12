module multi_pipe_4bit #(parameter size = 4)(
    input  wire                clk,
    input  wire                rst_n,
    input  wire [size-1:0]     mul_a,
    input  wire [size-1:0]     mul_b,
    output reg  [2*size-1:0]   mul_out
);

    // Extend multiplicand with zeros at MSB
    wire [2*size-1:0] a_ext = { {size{1'b0}}, mul_a };

    // Partial products: generate shifted versions or zero based on mul_b bits
    wire [2*size-1:0] partial [0:size-1];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_partial
            assign partial[i] = mul_b[i] ? (a_ext << i) : {2*size{1'b0}};
        end
    endgenerate

    // Stage 1 register: sum all partial products
    reg [2*size-1:0] stage1;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            stage1 <= 0;
        else
            stage1 <= partial[0] + partial[1] + partial[2] + partial[3];
    end

    // Stage 2 register: register the final output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out <= 0;
        else
            mul_out <= stage1;
    end

endmodule