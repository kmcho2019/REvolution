module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output [2*size-1:0] mul_out
);

    // Extend input signals by adding size number of zero bits at the most significant bit positions
    wire [2*size-1:0] ext_mul_a = { {size{1'b0}}, mul_a };
    wire [2*size-1:0] ext_mul_b = { {size{1'b0}}, mul_b };

    // Declare registers for intermediate sum values
    reg [2*size-1:0] reg1;
    reg [2*size-1:0] reg2;

    // Initialize registers to zero
    initial begin
        reg1 = 0;
        reg2 = 0;
    end

    // Perform multiplication for each bit position of the multiplier
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin: gen_loop
            wire [2*size-1:0] partial_product;
            if (ext_mul_b[i]) begin
                assign partial_product = { {i{1'b0}}, ext_mul_a };
            end else begin
                assign partial_product = 'd0;
            end

            // Add partial products and store in registers
            always @ (posedge clk or negedge rst_n) begin
                if (~rst_n) begin
                    reg1 <= 0;
                end else begin
                    if (i == 0) begin
                        reg1 <= partial_product;
                    end else begin
                        reg1 <= reg1 + partial_product;
                    end
                end
            end
        end
    endgenerate

    // Update final product output
    always @ (posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            reg2 <= 0;
            mul_out <= 0;
        end else begin
            reg2 <= reg1;
            mul_out <= reg2;
        end
    end
endmodule