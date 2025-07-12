module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    reg [6:0] counter; // 7-bit counter sufficient for counts up to 100

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            counter <= 7'd0;
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1 <= 1'b0;
        end else begin
            // Increment counter; wrap around at 99 to cover 0..99 (100 cycles)
            if (counter == 7'd99) begin
                counter <= 7'd0;
            end else begin
                counter <= counter + 7'd1;
            end

            // Toggle CLK_50 every clock cycle: equivalent to LSB of counter
            CLK_50 <= counter[0];

            // Toggle CLK_10 every 5 cycles: toggle at counter == 4, 9, 14, ..., 99
            // Generate a pulse when counter mod 10 == 4
            // So CLK_10 toggles when (counter % 10) == 4
            if (counter % 10 == 4)
                CLK_10 <= ~CLK_10;

            // Toggle CLK_1 every 50 cycles: toggle when counter == 49 or 99
            if (counter == 7'd49 || counter == 7'd99)
                CLK_1 <= ~CLK_1;
        end
    end

endmodule