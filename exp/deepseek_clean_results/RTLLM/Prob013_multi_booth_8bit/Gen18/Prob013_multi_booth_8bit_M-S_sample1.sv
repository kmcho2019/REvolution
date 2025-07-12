module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [15:0] mcand;    // Multiplicand (sign-extended)
    reg [8:0] mplier;    // Multiplier with extra bit for Booth
    reg [1:0] counter;   // Iteration counter (0-3)

    always @(posedge clk) begin
        if (reset) begin
            mcand <= {{8{a[7]}}, a};
            mplier <= {b, 1'b0};  // Extra bit for Booth encoding
            p <= 16'b0;
            counter <= 2'b0;
            rdy <= (a == 8'b0) || (b == 8'b0);
        end
        else if (!rdy) begin
            // Booth encoding and product update
            case (mplier[2:0])
                3'b001, 3'b010: p <= p + mcand;
                3'b011:         p <= p + (mcand << 1);
                3'b100:         p <= p - (mcand << 1);
                3'b101, 3'b110: p <= p - mcand;
                default:       p <= p;
            endcase

            // Update registers
            mcand <= mcand << 2;
            mplier <= mplier >> 2;
            counter <= counter + 1;

            // Completion detection
            rdy <= (counter == 2'b11);
        end
    end

endmodule