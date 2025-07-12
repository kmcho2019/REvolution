module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // The maximum count for 1MHz half period (toggle every 50 cycles)
    localparam MAX_COUNT = 99;  // 0 to 99 = 100 cycles total for full period of 1MHz clock

    reg [6:0] counter;  // 7 bits to cover 0-99

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            counter <= 7'd0;
            CLK_50  <= 1'b0;
            CLK_10  <= 1'b0;
            CLK_1   <= 1'b0;
        end else begin
            if (counter == MAX_COUNT) begin
                counter <= 7'd0;
            end else begin
                counter <= counter + 7'd1;
            end

            // Toggle CLK_50 every 1 count (half period = 1)
            // So toggle at counter = 0 and 1 -> effectively every clock cycle, divide by 2
            if (counter == 0 || counter == 1) begin
                CLK_50 <= ~CLK_50;
            end

            // Toggle CLK_10 every 5 counts (half period = 5)
            // Counts at 0,5,10,... but toggle only when counter mod 10 == 0
            if ((counter % 10) == 0) begin
                CLK_10 <= ~CLK_10;
            end

            // Toggle CLK_1 every 50 counts (half period = 50)
            // Toggle at counter == 0 and counter == 50
            if (counter == 0 || counter == 50) begin
                CLK_1 <= ~CLK_1;
            end
        end
    end

endmodule