module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

    // Booth encoder signals
    wire [1:0] booth_sel [size/2:0];
    wire [size:0] booth_pp [size/2:0];
    reg [2*size-1:0] pp [size/2:0];
    
    // Extended multiplicand (sign extended for Booth)
    wire [size:0] ext_a = {mul_a[size-1], mul_a};
    wire [size:0] neg_a = ~ext_a + 1'b1;
    wire [size:0] twice_a = ext_a << 1;
    wire [size:0] twice_neg_a = neg_a << 1;

    // Generate Booth encoding groups
    assign booth_sel[0] = {mul_b[0], 1'b0};
    assign booth_sel[1] = mul_b[2:1];
    assign booth_sel[2] = mul_b[3:2];

    // Booth partial product selection
    generate
        genvar i;
        for (i = 0; i <= size/2; i = i + 1) begin : booth_mux
            always @(*) begin
                case (booth_sel[i])
                    2'b00, 2'b11: booth_pp[i] = '0;
                    2'b01: booth_pp[i] = ext_a;
                    2'b10: booth_pp[i] = neg_a;
                endcase
            end
        end
    endgenerate

    // Pipeline stage 1: Register partial products
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pp[0] <= '0;
            pp[1] <= '0;
            pp[2] <= '0;
        end else begin
            pp[0] <= {{(size-1){booth_pp[0][size]}}, booth_pp[0]};
            pp[1] <= {{(size-3){booth_pp[1][size]}}, booth_pp[1], 1'b0};
            pp[2] <= {{(size-5){booth_pp[2][size]}}, booth_pp[2], 3'b0};
        end
    end

    // Pipeline stage 2: Add partial products
    reg [2*size-1:0] sum_stage1;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage1 <= '0;
            mul_out <= '0;
        end else begin
            // First stage addition (balanced tree)
            sum_stage1 <= pp[0] + pp[1];
            
            // Final output (second stage addition)
            mul_out <= sum_stage1 + pp[2];
        end
    end

endmodule