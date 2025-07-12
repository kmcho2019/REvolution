module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [8:0] b,  // Changed to 9-bit to include initial prev_lsb
    output reg [15:0] p,
    output reg rdy
);

    reg [4:0] ctr;       // 5-bit counter (0-15)
    reg [15:0] multiplicand;
    reg [8:0] multiplier; // 9-bit (8 + prev_lsb)
    wire [2:0] booth_enc = multiplier[2:0];

    // Booth encoding cases
    always @(*) begin
        case (booth_enc)
            3'b000, 3'b111: p = p;                  // 0
            3'b001, 3'b010: p = p + multiplicand;    // +1
            3'b011:         p = p + (multiplicand << 1); // +2
            3'b100:         p = p - (multiplicand << 1); // -2
            3'b101, 3'b110: p = p - multiplicand;    // -1
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            p <= 16'b0;
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {b, 1'b0};  // Initialize with prev_lsb=0
            ctr <= 5'b0;
            rdy <= 1'b0;
        end else begin
            if (ctr < 16) begin
                // Arithmetic right shift multiplier (including prev_lsb)
                multiplier <= {multiplier[8], multiplier[8:1]};
                ctr <= ctr + 1;
                rdy <= (ctr == 15);
            end else begin
                rdy <= 1'b1;
            end
        end
    end

endmodule