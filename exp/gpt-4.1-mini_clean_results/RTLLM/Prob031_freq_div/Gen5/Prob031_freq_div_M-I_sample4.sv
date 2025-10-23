module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Define count limits as localparams for clarity
    localparam CNT_10_MAX  = 3'd4;  // Toggle CLK_10 every 5 cycles (divide by 10)
    localparam CNT_100_MAX = 6'd49; // Toggle CLK_1 every 50 cycles (divide by 100)

    // Counters for frequency division
    reg [2:0]  cnt_10;    // Counter for 10MHz clock
    reg [5:0]  cnt_100;   // Counter for 1MHz clock

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            // Asynchronous reset of clocks and counters
            CLK_50  <= 1'b0;
            CLK_10  <= 1'b0;
            CLK_1   <= 1'b0;
            cnt_10  <= 3'd0;
            cnt_100 <= 6'd0;
        end else begin
            // CLK_50 generation: toggle every clock (divide by 2)
            CLK_50 <= ~CLK_50;

            // CLK_10 generation
            if (cnt_10 == CNT_10_MAX) begin
                CLK_10 <= ~CLK_10;
                cnt_10 <= 3'd0;
            end else begin
                cnt_10 <= cnt_10 + 1'b1;
            end

            // CLK_1 generation
            if (cnt_100 == CNT_100_MAX) begin
                CLK_1 <= ~CLK_1;
                cnt_100 <= 6'd0;
            end else begin
                cnt_100 <= cnt_100 + 1'b1;
            end
        end
    end

endmodule