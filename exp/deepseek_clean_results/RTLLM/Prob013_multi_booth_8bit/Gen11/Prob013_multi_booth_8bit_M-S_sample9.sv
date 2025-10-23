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
    reg [2:0] counter;   // 3-bit counter for 4 iterations (0-3)

    always @(posedge clk) begin
        if (reset) begin
            mcand <= {{8{a[7]}}, a};
            mplier <= b;
            p <= 16'b0;
            counter <= 3'b0;
            rdy <= 1'b0;
        end else if (!rdy) begin
            case (mplier[1:0])
                2'b00: p <= p;                  // +0
                2'b01: p <= p + mcand;          // +1
                2'b10: p <= p - mcand;          // -1
                2'b11: p <= p - (mcand << 1);   // -2 (special case)
            endcase

            // Shift operations
            mcand <= mcand << 1;
            mplier <= mplier >> 1;
            
            counter <= counter + 1;
            rdy <= (counter == 3'd3);   // Done after 4 iterations
        end
    end

endmodule