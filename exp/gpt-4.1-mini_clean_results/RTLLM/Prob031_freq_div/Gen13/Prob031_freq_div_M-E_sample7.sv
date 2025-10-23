module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Parameters for half period counts
    localparam HALF_PERIOD_50  = 1;   // toggle every cycle for 50MHz (100MHz/2)
    localparam HALF_PERIOD_10a = 4;   // first toggle point for 10MHz (half of 10 cycles)
    localparam HALF_PERIOD_10b = 9;   // second toggle point to complete full period for 10MHz
    localparam HALF_PERIOD_1   = 49;  // toggle at half period 1MHz (half of 100 cycles)

    reg [6:0] counter;  // counts from 0 to 99

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            counter <= 7'd0;
            CLK_50  <= 1'b0;
            CLK_10  <= 1'b0;
            CLK_1   <= 1'b0;
        end else begin
            // Increment counter and wrap around at 100
            if (counter == 7'd99) begin
                counter <= 7'd0;
            end else begin
                counter <= counter + 7'd1;
            end

            // Toggle CLK_50 every cycle (divide by 2)
            CLK_50 <= ~CLK_50;

            // Toggle CLK_10 at counts 4 and 9 for 10 cycles full period
            if (counter == HALF_PERIOD_10a || counter == HALF_PERIOD_10b) begin
                CLK_10 <= ~CLK_10;
            end

            // Toggle CLK_1 at count 49 (half period 100 cycles)
            if (counter == HALF_PERIOD_1) begin
                CLK_1 <= ~CLK_1;
            end
        end
    end

endmodule