module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

reg [15:0] multiplicand;
reg [15:0] multiplier;
reg [4:0] ctr;
reg [15:0] product;
reg [1:0] state;

// Stage 1: Booth encoding
reg [7:0] booth_encoded;

// Stage 2: Partial product generation
reg [15:0] partial_product;

// Stage 3: Carry-save addition
reg [15:0] carry_save;

// Stage 4: Final addition
reg [15:0] final_product;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        multiplicand <= 0;
        multiplier <= 0;
        product <= 0;
        ctr <= 0;
        rdy <= 0;
        state <= 0;
    end else begin
        case (state)
            0: begin
                // Booth encoding
                booth_encoded <= b[7] ? ~a + 1 : a;
                state <= 1;
            end
            1: begin
                // Partial product generation
                partial_product <= multiplicand * booth_encoded;
                state <= 2;
            end
            2: begin
                // Carry-save addition
                carry_save <= carry_save + partial_product;
                state <= 3;
            end
            3: begin
                // Final addition
                final_product <= carry_save;
                p <= final_product;
                rdy <= 1;
                state <= 0;
            end
            default: begin
                state <= 0;
            end
        endcase
    end
end

endmodule