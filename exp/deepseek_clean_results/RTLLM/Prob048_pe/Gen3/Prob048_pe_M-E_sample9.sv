module pe #(
    parameter SIGNED = 1,          // 1 for signed, 0 for unsigned
    parameter OUTPUT_WIDTH = 32     // Output width (32 or 64)
) (
    input wire clk,
    input wire rst,
    input wire [31:0] a,
    input wire [31:0] b,
    output reg [OUTPUT_WIDTH-1:0] c
);

    // Pipeline registers
    reg [31:0] a_reg, b_reg;
    reg [63:0] product_reg;
    reg [63:0] acc_reg;

    // Internal signals
    wire [63:0] product;
    wire [63:0] next_acc;
    wire overflow;

    // Input stage registers
    always @(posedge clk) begin
        if (rst) begin
            a_reg <= 0;
            b_reg <= 0;
        end else begin
            a_reg <= a;
            b_reg <= b;
        end
    end

    // Multiplication stage
    generate
        if (SIGNED) begin
            assign product = $signed(a_reg) * $signed(b_reg);
        end else begin
            assign product = a_reg * b_reg;
        end
    endgenerate

    // Pipeline register after multiply
    always @(posedge clk) begin
        if (rst) begin
            product_reg <= 0;
        end else begin
            product_reg <= product;
        end
    end

    // Accumulation stage
    assign next_acc = acc_reg + product_reg;
    assign overflow = (OUTPUT_WIDTH == 32) ? 
                     (next_acc != $signed(next_acc[31:0])) : 1'b0;

    // Accumulator register and output logic
    always @(posedge clk) begin
        if (rst) begin
            acc_reg <= 0;
            c <= 0;
        end else begin
            acc_reg <= next_acc;
            
            // Saturation logic for 32-bit output
            if (OUTPUT_WIDTH == 32) begin
                if (overflow) begin
                    c <= next_acc[63] ? {1'b1, {31{1'b0}}} : {1'b0, {31{1'b1}};
                end else begin
                    c <= next_acc[31:0];
                end
            end else begin
                c <= next_acc;
            end
        end
    end

endmodule