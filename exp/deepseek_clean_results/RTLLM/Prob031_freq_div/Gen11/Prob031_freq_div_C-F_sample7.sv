module freq_div (
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Division factors
    parameter DIV_50 = 2;
    parameter DIV_10 = 10;
    parameter DIV_1 = 100;

    // Calculate optimal counter widths
    localparam CNT_10_WIDTH = $clog2(DIV_10/2);
    localparam CNT_1_WIDTH = $clog2(DIV_1/2);

    // Counters (down-counting)
    reg [CNT_10_WIDTH-1:0] cnt10;
    reg [CNT_1_WIDTH-1:0] cnt100;

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            // Reset all outputs and counters
            CLK_50 <= 0;
            CLK_10 <= 0;
            CLK_1 <= 0;
            cnt10 <= (DIV_10/2)-1;
            cnt100 <= (DIV_1/2)-1;
        end else begin
            // 50MHz - simple toggle
            CLK_50 <= ~CLK_50;

            // 10MHz generation
            if (cnt10 == 0) begin
                CLK_10 <= ~CLK_10;
                cnt10 <= (DIV_10/2)-1;
            end else begin
                cnt10 <= cnt10 - 1;
            end

            // 1MHz generation
            if (cnt100 == 0) begin
                CLK_1 <= ~CLK_1;
                cnt100 <= (DIV_1/2)-1;
            end else begin
                cnt100 <= cnt100 - 1;
            end
        end
    end

endmodule