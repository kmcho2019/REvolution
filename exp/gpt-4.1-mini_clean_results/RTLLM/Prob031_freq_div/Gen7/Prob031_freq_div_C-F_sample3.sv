module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Shared counter for 10MHz and 1MHz outputs
    reg [5:0] counter;

    // Constants for toggle points
    localparam CNT_10_TOGGLE = 6'd4;  // toggle every 5 cycles -> divide by 10
    localparam CNT_100_TOGGLE = 6'd49; // toggle every 50 cycles -> divide by 100

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1  <= 1'b0;
            counter <= 6'd0;
        end else begin
            // Toggle 50MHz clock every cycle (divide by 2)
            CLK_50 <= ~CLK_50;

            // Increment shared counter; wrap at 49 (for 1MHz)
            if (counter == CNT_100_TOGGLE)
                counter <= 6'd0;
            else
                counter <= counter + 6'd1;

            // Toggle 10MHz clock at counter == 4 (every 5 cycles)
            if (counter == CNT_10_TOGGLE)
                CLK_10 <= ~CLK_10;

            // Toggle 1MHz clock at counter == 49 (every 50 cycles)
            if (counter == CNT_100_TOGGLE)
                CLK_1 <= ~CLK_1;
        end
    end

endmodule