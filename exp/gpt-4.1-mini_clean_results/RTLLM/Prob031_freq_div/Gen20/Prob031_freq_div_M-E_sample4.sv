module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Central counter counts from 0 to 99 for 1MHz base period
    reg [6:0] cnt; // 7 bits sufficient for counting to 99

    // Toggle enables generated when counter reaches half period for each output
    wire toggle_50;
    wire toggle_10;
    wire toggle_1;

    // Half periods (toggle points)
    localparam HALF_50 = 1 - 1;  // toggles every clock, so half period = 1 cycle
    localparam HALF_10 = 5 - 1;  // toggle every 5 clocks (half period = 5)
    localparam HALF_1  = 50 - 1; // toggle every 50 clocks (half period = 50)

    assign toggle_50 = (cnt == HALF_50);
    assign toggle_10 = (cnt == HALF_10);
    assign toggle_1  = (cnt == HALF_1);

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt    <= 7'd0;
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1  <= 1'b0;
        end else begin
            // Increment counter modulo 100
            if (cnt == 7'd99)
                cnt <= 7'd0;
            else
                cnt <= cnt + 7'd1;

            // Toggle CLK_50 every 1 clock cycle (cnt == 0)
            if (toggle_50)
                CLK_50 <= ~CLK_50;

            // Toggle CLK_10 every 5 clock cycles (cnt == 4)
            if (toggle_10)
                CLK_10 <= ~CLK_10;

            // Toggle CLK_1 every 50 clock cycles (cnt == 49)
            if (toggle_1)
                CLK_1 <= ~CLK_1;
        end
    end

endmodule