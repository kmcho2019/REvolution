module freq_div (
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Fixed division factors (constants for optimization)
    localparam DIV_50 = 2;
    localparam DIV_10 = 10;
    localparam DIV_1 = 10; // Now relative to CLK_10

    // Counter widths (optimized for fixed divisions)
    localparam CNT_10_WIDTH = 3; // $clog2(5) = 3
    localparam CNT_1_WIDTH = 3;  // $clog2(5) = 3

    // Gray code counters (reduces switching activity)
    reg [CNT_10_WIDTH-1:0] cnt10;
    reg [CNT_10_WIDTH-1:0] cnt10_gray;
    reg [CNT_1_WIDTH-1:0] cnt1;
    reg [CNT_1_WIDTH-1:0] cnt1_gray;

    // 50MHz generation (separate always block)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 0;
        end else begin
            CLK_50 <= ~CLK_50;
        end
    end

    // 10MHz and 1MHz generation
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            // Reset outputs and counters
            CLK_10 <= 0;
            CLK_1 <= 0;
            cnt10 <= 4; // DIV_10/2 - 1
            cnt1 <= 4;   // DIV_1/2 - 1
            cnt10_gray <= 3'b110; // Gray code for 4
            cnt1_gray <= 3'b110;  // Gray code for 4
        end else begin
            // 10MHz generation with Gray counter
            if (cnt10 == 0) begin
                CLK_10 <= ~CLK_10;
                cnt10 <= 4;
                cnt10_gray <= 3'b110;
            end else begin
                cnt10 <= cnt10 - 1;
                cnt10_gray <= {cnt10_gray[CNT_10_WIDTH-2:0], cnt10_gray[CNT_10_WIDTH-1]};
            end

            // 1MHz generation (from CLK_10 domain)
            if (CLK_10) begin
                if (cnt1 == 0) begin
                    CLK_1 <= ~CLK_1;
                    cnt1 <= 4;
                    cnt1_gray <= 3'b110;
                end else begin
                    cnt1 <= cnt1 - 1;
                    cnt1_gray <= {cnt1_gray[CNT_1_WIDTH-2:0], cnt1_gray[CNT_1_WIDTH-1]};
                end
            end
        end
    end

endmodule