module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    reg [6:0] counter; // Enough bits to count up to 99

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            counter <= 7'd0;
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1  <= 1'b0;
        end else begin
            // Increment counter modulo 100
            if (counter == 7'd99)
                counter <= 7'd0;
            else
                counter <= counter + 1'b1;

            // CLK_50 toggles every 1 cycle (divide by 2)
            CLK_50 <= ~CLK_50;

            // CLK_10 toggles every 5 cycles (i.e., on counts 4,9,14,...)
            if (counter % 10 == 4)
                CLK_10 <= ~CLK_10;

            // CLK_1 toggles every 50 cycles (on counts 49 and 99)
            if (counter == 7'd49 || counter == 7'd99)
                CLK_1 <= ~CLK_1;
        end
    end

endmodule