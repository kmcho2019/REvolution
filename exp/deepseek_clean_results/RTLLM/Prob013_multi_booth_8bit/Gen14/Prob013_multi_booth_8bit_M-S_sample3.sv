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
    reg [4:0] counter;
    reg prev_bit;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize with sign-extended values
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= b;
            p <= 16'b0;
            counter <= 5'b0;
            prev_bit <= 1'b0;
            rdy <= 1'b0;
        end
        else if (!rdy) begin
            // Booth encoding and partial product addition
            case ({multiplier[1:0], prev_bit})
                3'b000, 3'b111: ; // No operation
                3'b001, 3'b010: p <= p + multiplicand;
                3'b011: p <= p + (multiplicand << 1);
                3'b100: p <= p - (multiplicand << 1);
                3'b101, 3'b110: p <= p - multiplicand;
            endcase

            // Update registers for next cycle
            multiplicand <= multiplicand << 2;
            multiplier <= multiplier >> 2;
            prev_bit <= multiplier[1];
            counter <= counter + 1;

            // Check completion
            if (counter == 5'b10000) begin
                rdy <= 1'b1;
            end
        end
    end

endmodule