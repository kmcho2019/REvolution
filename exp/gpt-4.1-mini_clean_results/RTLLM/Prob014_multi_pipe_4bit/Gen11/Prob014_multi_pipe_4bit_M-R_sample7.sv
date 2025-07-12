module multi_pipe_4bit #(parameter size = 4) (
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    localparam ext_size = 2 * size;

    // Stage 1 registers: extended multiplicand and multiplier
    reg [ext_size-1:0] reg_mul_a_ext;
    reg [size-1:0]     reg_mul_b;

    // Partial products as wires
    wire [ext_size-1:0] partials [size-1:0];

    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_partials
            assign partials[i] = reg_mul_b[i] ? (reg_mul_a_ext << i) : {ext_size{1'b0}};
        end
    endgenerate

    // Stage 1: register inputs with multiplicand extended by size zeros on MSB side
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_mul_a_ext <= {ext_size{1'b0}};
            reg_mul_b     <= {size{1'b0}};
        end else begin
            reg_mul_a_ext <= { {size{1'b0}}, mul_a };
            reg_mul_b     <= mul_b;
        end
    end

    // Stage 2: sum partial products and register output
    reg [2*size-1:0] sum_partials;

    integer j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_partials <= {2*size{1'b0}};
            mul_out      <= {2*size{1'b0}};
        end else begin
            // Sum partial products
            sum_partials <= {2*size{1'b0}};
            for (j = 0; j < size; j = j + 1) begin
                sum_partials <= sum_partials + partials[j];
            end
            mul_out <= sum_partials;
        end
    end

endmodule