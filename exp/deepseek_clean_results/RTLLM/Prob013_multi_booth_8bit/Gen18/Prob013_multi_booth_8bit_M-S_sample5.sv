module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [15:0] mcand;        // Sign-extended multiplicand
    reg [4:0] counter;       // 5-bit counter (0-15)
    wire [2:0] booth_bits;   // Current Booth encoding bits

    // Current Booth encoding bits (b[1:0] plus previous bit)
    assign booth_bits = {b[counter+1], b[counter], counter > 0 ? b[counter-1] : 1'b0};

    always @(posedge clk) begin
        if (reset) begin
            // Initialize registers
            mcand <= {{8{a[7]}}, a};
            p <= 16'b0;
            counter <= 5'b0;
            rdy <= 1'b0;
        end
        else if (!rdy) begin
            // Booth encoding and product update
            case (booth_bits)
                3'b001, 3'b010: p <= p + mcand;      // +1
                3'b011:         p <= p + (mcand << 1);// +2
                3'b100:         p <= p - (mcand << 1);// -2
                3'b101, 3'b110: p <= p - mcand;      // -1
                default:        ;                    // +0 (000,111)
            endcase

            // Shift multiplicand and increment counter
            mcand <= mcand << 2;
            counter <= counter + 2;

            // Completion detection (after 8 bits processed)
            if (counter >= 5'd14) begin
                rdy <= 1'b1;
            end
        end
    end

endmodule