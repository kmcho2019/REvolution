module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Parameters for division factors
    parameter DIV_50 = 2;
    parameter DIV_10 = 10;
    parameter DIV_1 = 100;
    
    // Precisely sized counter widths
    localparam CNT_10_WIDTH = $clog2(DIV_10/2);  // counts 0-4 (5 cycles)
    localparam CNT_1_WIDTH = $clog2(DIV_1/2);    // counts 0-49 (50 cycles)

    // Counters
    reg [CNT_10_WIDTH-1:0] cnt_10;
    reg [CNT_1_WIDTH-1:0] cnt_100;

    // CLK_50 generation (divide by 2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end else begin
            CLK_50 <= ~CLK_50;
        end
    end

    // CLK_10 generation (divide by 10)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_10 <= 1'b0;
            cnt_10 <= (DIV_10/2)-1;  // count down from 4 to 0
        end else begin
            if (cnt_10 == 0) begin
                CLK_10 <= ~CLK_10;
                cnt_10 <= (DIV_10/2)-1;
            end else begin
                cnt_10 <= cnt_10 - 1'b1;
            end
        end
    end

    // CLK_1 generation (divide by 100)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_1 <= 1'b0;
            cnt_100 <= (DIV_1/2)-1;  // count down from 49 to 0
        end else begin
            if (cnt_100 == 0) begin
                CLK_1 <= ~CLK_1;
                cnt_100 <= (DIV_1/2)-1;
            end else begin
                cnt_100 <= cnt_100 - 1'b1;
            end
        end
    end

endmodule