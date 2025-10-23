module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Pipeline registers
    reg [7:0] a_reg, b_reg;
    reg [15:0] partial_products [0:3];
    reg [15:0] result_reg;
    reg [1:0] en_pipeline;

    // Booth encoder outputs
    wire [2:0] booth_sel [0:3];
    wire [8:0] booth_a = {mul_a[7], mul_a}; // Sign extended multiplicand

    // Generate Booth encoding groups
    assign booth_sel[0] = {mul_b[1], mul_b[0], 1'b0};
    assign booth_sel[1] = mul_b[3:1];
    assign booth_sel[2] = mul_b[5:3];
    assign booth_sel[3] = mul_b[7:5];

    // Booth decoder (combinational)
    function [16:0] booth_decoder;
        input [8:0] a;
        input [2:0] sel;
        begin
            case (sel)
                3'b000, 3'b111: booth_decoder = 17'b0;
                3'b001, 3'b010: booth_decoder = {a[8], a};
                3'b011:         booth_decoder = {a, 1'b0};
                3'b100:         booth_decoder = {~a, 1'b0} + 1'b1;
                3'b101, 3'b110: booth_decoder = {(~a[8]), ~a} + 1'b1;
                default:       booth_decoder = 17'b0;
            endcase
        end
    endfunction

    // Generate partial products with proper shifting
    wire [16:0] pp0 = booth_decoder(booth_a, booth_sel[0]);
    wire [16:0] pp1 = booth_decoder(booth_a, booth_sel[1]) << 2;
    wire [16:0] pp2 = booth_decoder(booth_a, booth_sel[2]) << 4;
    wire [16:0] pp3 = booth_decoder(booth_a, booth_sel[3]) << 6;

    // Wallace tree reduction (4:2 compressor)
    wire [15:0] sum1, carry1;
    wire [15:0] sum2, carry2;

    // First level of compression
    assign {carry1, sum1} = pp0[15:0] + pp1[15:0] + pp2[15:0];
    assign carry1 = carry1 << 1;

    // Second level of compression
    assign {carry2, sum2} = sum1 + carry1 + pp3[15:0];
    assign carry2 = carry2 << 1;

    // Final addition (carry-select implementation)
    wire [15:0] final_sum = sum2 + carry2;

    // Pipeline control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 8'b0;
            b_reg <= 8'b0;
            result_reg <= 16'b0;
            en_pipeline <= 2'b0;
        end else begin
            // Stage 1: Register inputs and generate partial products
            a_reg <= mul_a;
            b_reg <= mul_b;
            
            // Stage 2: Register final result
            result_reg <= final_sum;
            
            // Enable signal pipeline
            en_pipeline <= {en_pipeline[0], mul_en_in};
        end
    end

    // Output assignments
    assign mul_en_out = en_pipeline[1];
    assign mul_out = en_pipeline[1] ? result_reg : 16'b0;

endmodule