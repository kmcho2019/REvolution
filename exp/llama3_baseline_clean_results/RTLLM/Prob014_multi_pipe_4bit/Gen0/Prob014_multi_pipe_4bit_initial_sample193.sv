module multi_pipe_4bit #(
    parameter size = 4
)(
    input               clk,
    input               rst_n,
    input  [size-1:0]   mul_a,
    input  [size-1:0]   mul_b,
    output [2*size-1:0] mul_out
);

    // Extended input signals
    wire [2*size-1:0] extended_mul_a;
    assign extended_mul_a = { {size{1'b0}}, mul_a };

    // Register to store intermediate values
    reg [2*size-1:0] reg1;
    reg [2*size-1:0] reg2;

    // Initialize registers
    initial begin
        reg1 = 0;
        reg2 = 0;
    end

    // Reset logic
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            reg1 <= 0;
            reg2 <= 0;
            mul_out <= 0;
        end
        else begin
            // Generate block to perform multiplication
            reg [2*size-1:0] partial_product;
            integer i;
            for (i = 0; i < size; i = i + 1) begin
                if (mul_b[i]) begin
                    partial_product = extended_mul_a << i;
                end
                else begin
                    partial_product = 0;
                end
                // Update registers
                if (i == 0) begin
                    reg1 <= partial_product;
                end
                else begin
                    reg1 <= reg1 + partial_product;
                end
            end
            // Update final product
            reg2 <= reg1;
            mul_out <= reg2;
        end
    end

    // Add of partial products
    always @(posedge clk) begin
        if (~rst_n) begin
            reg1 <= 0;
            reg2 <= 0;
        end
        else begin
            // Generate block to perform addition
            integer i;
            reg [2*size-1:0] sum;
            sum = 0;
            for (i = 0; i < size; i = i + 1) begin
                if (mul_b[i]) begin
                    sum = sum + (extended_mul_a << i);
                end
            end
            reg1 <= sum;
            reg2 <= reg1;
            mul_out <= reg2;
        end
    end

endmodule