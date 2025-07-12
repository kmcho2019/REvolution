module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [2:0] counter;    // 3-bit counter (0-4)
    reg [7:0] mplier;     // Working copy of multiplier
    wire [15:0] mcand = {{8{a[7]}}, a};  // Sign-extended multiplicand
    wire [15:0] mcand_x2 = mcand << 1;   // Pre-compute 2x multiplicand

    always @(posedge clk) begin
        if (reset) begin
            p <= 16'b0;
            mplier <= b;
            counter <= 3'b0;
            rdy <= 1'b0;
        end else if (!rdy) begin
            case (mplier[1:0])
                2'b01: p <= p + mcand;       // +1
                2'b10: p <= p - mcand;       // -1
                2'b11: p <= p + mcand_x2;     // +2
                2'b00: p <= p - mcand_x2;    // -2
            endcase

            mplier <= mplier >> 2;       // Shift multiplier right by 2
            counter <= counter + 1;
            rdy <= (counter == 3'b100);  // Done after 4 iterations
        end
    end

endmodule