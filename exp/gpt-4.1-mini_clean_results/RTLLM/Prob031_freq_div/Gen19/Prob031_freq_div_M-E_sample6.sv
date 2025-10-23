module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    reg [6:0] counter;  // Counts 0 to 99

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            counter <= 7'd0;
            CLK_50  <= 1'b0;
            CLK_10  <= 1'b0;
            CLK_1   <= 1'b0;
        end else begin
            // Increment counter or wrap around
            if (counter == 7'd99)
                counter <= 7'd0;
            else
                counter <= counter + 7'd1;

            // Toggle 50MHz clock every cycle (divide by 2)
            CLK_50 <= ~CLK_50;

            // Toggle 10MHz clock twice per 10 counts (at 4 and 9)
            if (counter == 7'd4 || counter == 7'd9)
                CLK_10 <= ~CLK_10;

            // Toggle 1MHz clock twice per 100 counts (at 49 and 99)
            if (counter == 7'd49 || counter == 7'd99)
                CLK_1 <= ~CLK_1;
        end
    end

endmodule