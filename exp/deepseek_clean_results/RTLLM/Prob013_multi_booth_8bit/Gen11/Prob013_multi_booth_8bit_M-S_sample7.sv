module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [15:0] multiplicand;
    reg [15:0] multiplicand_x2;  // Pre-computed multiplicand*2
    reg [7:0] multiplier;
    reg [1:0] counter;

    always @(posedge clk) begin
        if (reset) begin
            // Initialize with sign extension
            multiplicand <= {{8{a[7]}}, a};
            multiplicand_x2 <= {{8{a[7]}}, a} << 1;
            multiplier <= b;
            p <= 16'b0;
            counter <= 2'b0;
            rdy <= 1'b0;
        end else if (!rdy) begin
            // Booth encoding and accumulation
            case (multiplier[1:0])
                2'b00: p <= p;
                2'b01: p <= p + multiplicand;
                2'b10: p <= p + multiplicand_x2;
                2'b11: p <= p - multiplicand;
            endcase

            // Update for next iteration
            multiplicand <= multiplicand << 2;
            multiplicand_x2 <= multiplicand_x2 << 2;
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