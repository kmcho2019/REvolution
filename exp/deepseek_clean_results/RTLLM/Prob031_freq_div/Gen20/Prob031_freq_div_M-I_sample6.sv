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
    
    // Calculate precise counter widths
    localparam CNT_50_WIDTH = $clog2(DIV_50);
    localparam CNT_10_WIDTH = $clog2(DIV_10/2);
    localparam CNT_1_WIDTH = $clog2(DIV_1/2);
    
    // Dedicated counters for each clock
    reg [CNT_50_WIDTH-1:0] cnt_50;
    reg [CNT_10_WIDTH-1:0] cnt_10;
    reg [CNT_1_WIDTH-1:0] cnt_1;

    // CLK_50 generation (divide by 2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
            cnt_50 <= 0;
        end else begin
            if (cnt_50 == DIV_50/2 - 1) begin
                CLK_50 <= ~CLK_50;
                cnt_50 <= 0;
            end else begin
                cnt_50 <= cnt_50 + 1'b1;
            end
        end
    end

    // CLK_10 generation (divide by 10)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_10 <= 1'b0;
            cnt_10 <= 0;
        end else begin
            if (cnt_10 == DIV_10/2 - 1) begin
                CLK_10 <= ~CLK_10;
                cnt_10 <= 0;
            end else begin
                cnt_10 <= cnt_10 + 1'b1;
            end
        end
    end

    // CLK_1 generation (divide by 100)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_1 <= 1'b0;
            cnt_1 <= 0;
        end else begin
            if (cnt_1 == DIV_1/2 - 1) begin
                CLK_1 <= ~CLK_1;
                cnt_1 <= 0;
            end else begin
                cnt_1 <= cnt_1 + 1'b1;
            end
        end
    end

endmodule