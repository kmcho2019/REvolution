module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output [2*size-1:0] mul_out
);

    reg [2*size-1:0] reg1, reg2;
    reg [2*size-1:0] partial_product;
    reg [2*size-1:0] temp;

    // Initialize registers
    initial begin
        reg1 = 0;
        reg2 = 0;
    end

    // Reset logic
    always @(posedge rst_n or negedge rst_n) begin
        if (~rst_n) begin
            reg1 <= 0;
            reg2 <= 0;
            mul_out <= 0;
        end
    end

    // First stage of pipeline
    always @(posedge clk) begin
        if (rst_n) begin
            // Generate partial products and add them to reg1
            reg1 <= 0;
            for (int i = 0; i < size; i++) begin
                if (mul_b[i] == 1) begin
                    partial_product = {size{1'b0}} << (i + size);
                    partial_product[7:4] = mul_a;
                    reg1 <= reg1 + partial_product;
                end
            end
        end
    end

    // Second stage of pipeline
    always @(posedge clk) begin
        if (rst_n) begin
            // Add reg1 to reg2
            reg2 <= reg1;
            mul_out <= reg2;
        end
    end

endmodule