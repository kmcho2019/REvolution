module multi_pipe_4bit #(
    parameter size = 4
)(
    input   clk,
    input   rst_n,
    input   [size-1:0] mul_a,
    input   [size-1:0] mul_b,
    output  [2*size-1:0] mul_out
);

    // Extended input signals
    wire [2*size-1:0] ext_mul_a;
    assign ext_mul_a = { {(size){1'b0}}, mul_a };

    // Generate block for partial products
    wire [2*size-1:0] partial_product [size-1:0];
    genvar i;
    generate
        for (i = 0; i < size; i++) begin
            assign partial_product[i] = (mul_b[i] == 1'b1)? (ext_mul_a << i) : { {(2*size){1'b0}} };
        end
    endgenerate

    // Registers for intermediate sum values
    reg [2*size-1:0] reg1;
    reg [2*size-1:0] reg2;

    // Add operation for partial products
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            reg1 <= { {(2*size){1'b0}} };
            reg2 <= { {(2*size){1'b0}} };
        end else begin
            reg1 <= partial_product[0];
            reg2 <= partial_product[1] + partial_product[2] + partial_product[3];
        end
    end

    // Final product calculation
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            mul_out <= { {(2*size){1'b0}} };
        end else begin
            mul_out <= reg1 + reg2;
        end
    end

endmodule