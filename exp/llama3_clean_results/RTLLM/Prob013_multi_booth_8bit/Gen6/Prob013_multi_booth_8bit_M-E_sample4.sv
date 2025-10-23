module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

// Stage 1: Input registers
reg [7:0] multiplicand_reg;
reg [7:0] multiplier_reg;

// Stage 2: Bit-select and shift unit
reg [15:0] multiplicand_shifted;
reg [4:0] ctr;

// Stage 3: Booth encoder
reg [1:0] booth_encoder_out;

// Stage 4: Product accumulator
reg [15:0] product_accumulator;

always @(posedge clk) begin
    if(reset) begin
        multiplicand_reg <= b;
        multiplier_reg <= a;
        multiplicand_shifted <= { {8{b[7]}}, b };
        ctr <= 0;
        product_accumulator <= 0;
        rdy <= 0;
    end else if(ctr < 8) begin
        // Booth encoder
        booth_encoder_out <= { multiplier_reg[ctr], multiplier_reg[ctr-1] };
        
        // Product accumulator
        case(booth_encoder_out)
            2'b00: product_accumulator <= product_accumulator;
            2'b01: product_accumulator <= product_accumulator + multiplicand_shifted;
            2'b10: product_accumulator <= product_accumulator - multiplicand_shifted;
            2'b11: product_accumulator <= product_accumulator;
        endcase
        
        // Bit-select and shift unit
        multiplicand_shifted <= multiplicand_shifted << 1;
        ctr <= ctr + 1;
    end else begin
        p <= product_accumulator;
        rdy <= 1;
    end
end

endmodule