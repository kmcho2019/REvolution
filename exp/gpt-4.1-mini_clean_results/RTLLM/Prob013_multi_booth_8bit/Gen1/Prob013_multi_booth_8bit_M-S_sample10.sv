module multi_booth_8bit (
    input wire clk,
    input wire reset,
    input wire [7:0] a,    // multiplicand
    input wire [7:0] b,    // multiplier
    output reg [15:0] p,
    output reg rdy
);

    reg signed [15:0] multiplicand;
    reg [9:0] booth_reg; // multiplier extended with an extra bit at LSB for Booth encoding (8 bits +1)
    reg [3:0] count;     // count from 0 to 4 (4 cycles)
    reg signed [17:0] acc; // accumulator to hold intermediate sum (wider for shifts and adds)

    // Function to decode 3 bits into a multiplicand multiple based on Radix-4 Booth encoding
    function signed [17:0] booth_decode;
        input [2:0] bits;
        input signed [15:0] m;
        begin
            case(bits)
                3'b000, 3'b111: booth_decode = 18'd0;
                3'b001, 3'b010: booth_decode = { {2{m[15]}}, m };        // +1*multiplicand
                3'b011:         booth_decode = { {1{m[15]}}, m, 1'b0 };  // +2*multiplicand (shift left 1)
                3'b100:         booth_decode = -({ {1{m[15]}}, m, 1'b0 }); // -2*multiplicand
                3'b101, 3'b110: booth_decode = -({ {2{m[15]}}, m });       // -1*multiplicand
                default:        booth_decode = 18'd0; // default safe
            endcase
        end
    endfunction

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplicand <= $signed({a[7], a}); // sign-extend a to 16 bits
            // Append one zero bit at LSB for Booth algorithm (shifted multiplier with extra bit)
            booth_reg <= {b, 1'b0};
            acc <= 18'd0;
            count <= 4'd0;
            p <= 16'd0;
            rdy <= 1'b0;
        end else if (!rdy) begin
            if (count < 4) begin
                // Extract 3 bits for current Booth group: bits [2*count+1 : 2*count-1]
                // For count=0: bits [1: -1], negative index is zero padded as zero
                // So we build bits with care:
                // bit_minus_1 = (2*count == 0)? 0 : booth_reg[2*count -1]
                integer idx = 2*count;
                reg [2:0] booth_bits;
                booth_bits[0] = (idx == 0) ? 1'b0 : booth_reg[idx -1];
                booth_bits[1] = booth_reg[idx];
                booth_bits[2] = booth_reg[idx +1];

                // Decode partial product
                // The output is signed 18 bits to allow shifts and sign extensions
                reg signed [17:0] pp;
                pp = booth_decode(booth_bits, multiplicand);

                // Add partial product shifted by 2*count bits
                acc <= acc + (pp << (2*count));
                count <= count + 1'b1;
            end else begin
                // Finished all 4 groups (8 bits), output lower 16 bits as product
                p <= acc[15:0];
                rdy <= 1'b1;
            end
        end
    end

endmodule