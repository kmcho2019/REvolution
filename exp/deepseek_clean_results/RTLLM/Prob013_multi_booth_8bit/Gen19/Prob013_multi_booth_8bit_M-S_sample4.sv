module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [15:0] mcand;    // Multiplicand (sign extended)
    reg [7:0] mplier;    // Multiplier (right shifted)
    reg [1:0] counter;   // 2-bit counter for 4 iterations
    reg prev_bit;        // Previous bit for Booth encoding

    always @(posedge clk) begin
        if (reset) begin
            mcand <= {{8{a[7]}}, a};
            mplier <= b;
            p <= 16'b0;
            counter <= 2'b0;
            prev_bit <= 1'b0;
            rdy <= 1'b0;
        end else if (!rdy) begin
            case ({mplier[1:0], prev_bit})
                3'b000, 3'b111: p <= p;                  // +0
                3'b001, 3'b010: p <= p + mcand;          // +1
                3'b011: p <= p + (mcand << 1);           // +2
                3'b100: p <= p - (mcand << 1);           // -2
                3'b101, 3'b110: p <= p - mcand;          // -1
            endcase

            mcand <= mcand << 2;         // Shift multiplicand left by 2
            mplier <= mplier >> 2;       // Shift multiplier right by 2
            prev_bit <= mplier[1];        // Save previous bit
            counter <= counter + 1;
            rdy <= (counter == 2'b11);   // Done after 4 iterations
        end
    end

endmodule