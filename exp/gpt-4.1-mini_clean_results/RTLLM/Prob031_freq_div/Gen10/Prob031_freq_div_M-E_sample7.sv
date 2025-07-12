module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    reg [6:0] counter; // 7 bits to count up to 100 (max count is 99)

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            counter <= 7'd0;
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1  <= 1'b0;
        end else begin
            if (counter == 7'd99) 
                counter <= 7'd0;
            else
                counter <= counter + 7'd1;

            // CLK_50 toggles every 1 CLK_in cycle (divide by 2)
            // It can be derived from the LSB of the counter.
            CLK_50 <= counter[0];

            // CLK_10 toggles every 5 CLK_in cycles (divide by 10)
            // Use bit 2 (counting from 0) to toggle every 5 cycles
            // i.e., toggle half period at 5 cycles
            CLK_10 <= counter[3]; // counter[3] toggles every 8 counts, so adjust

            // Since toggle should happen every 5 cycles, 
            // we generate CLK_10 by checking counter mod 10 < 5 or >=5
            // This requires a small combinational logic:

            // We'll implement CLK_10 as high for count 0 to 4, low for 5 to 9, repeating.
            // But since counter counts to 99, we can use counter%10 <5 as high else low.
            // We'll implement this with combinational logic below.

            // CLK_1 toggles every 50 cycles (divide by 100)
            // High for 50 counts, low for 50 counts.

            // We'll implement CLK_10 and CLK_1 combinationally below after counter update.
        end
    end

    // Combinational process for CLK_10 and CLK_1 based on counter value
    always @(*) begin
        if (RST) begin
            CLK_10 = 1'b0;
            CLK_1  = 1'b0;
        end else begin
            // CLK_10: High when counter mod 10 < 5
            if ((counter % 10) < 5)
                CLK_10 = 1'b1;
            else
                CLK_10 = 1'b0;

            // CLK_1: High when counter < 50, low when counter >= 50
            if (counter < 50)
                CLK_1 = 1'b1;
            else
                CLK_1 = 1'b0;
        end
    end

endmodule