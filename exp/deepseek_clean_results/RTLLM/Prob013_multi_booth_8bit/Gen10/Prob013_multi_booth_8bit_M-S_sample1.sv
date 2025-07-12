module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [15:0] multiplicand;
    reg [7:0] multiplier;
    reg prev_lsb;
    reg [1:0] counter;

    always @(posedge clk) begin
        if (reset) begin
            // Initialize with sign extension
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= b;
            prev_lsb <= 1'b0;
            p <= 16'b0;
            counter <= 2'b0;
            rdy <= 1'b0;
        end else if (!rdy) begin
            // Booth encoding and accumulation
            case ({multiplier[1:0], prev_lsb})
                3'b000, 3'b111: p <= p;
                3'b001, 3'b010: p <= p + multiplicand;
                3'b011:         p <= p + (multiplicand << 1);
                3'b100:         p <= p - (multiplicand << 1);
                3'b101, 3'b110: p <= p - multiplicand;
            endcase

            // Update for next iteration
            multiplicand <= multiplicand << 2;
            prev_lsb <= multiplier[1];
            multiplier <= multiplier >> 2;

            // Check completion
            if (counter == 2'b11) begin
                rdy <= 1'b1;
            end else begin
                counter <= counter + 1;
            end
        end
    end

endmodule