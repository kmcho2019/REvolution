module freq_div (
    input CLK_in,
    input RST,
    output CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // 50MHz clock - simple toggle with assign
    reg clk50_reg;
    assign CLK_50 = clk50_reg;

    // 10MHz generation parameters
    localparam DIV10_COUNT = 4;  // 100MHz/10MHz/2 - 1
    reg [2:0] cnt10;

    // 1MHz generation parameters
    localparam DIV100_COUNT = 49;  // 100MHz/1MHz/2 - 1
    reg [5:0] cnt100;

    // 50MHz clock generation
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            clk50_reg <= 0;
        end else begin
            clk50_reg <= ~clk50_reg;
        end
    end

    // 10MHz clock generation
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_10 <= 0;
            cnt10 <= 0;
        end else begin
            if (cnt10 == DIV10_COUNT) begin
                CLK_10 <= ~CLK_10;
                cnt10 <= 0;
            end else begin
                cnt10 <= cnt10 + 1;
            end
        end
    end

    // 1MHz clock generation
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_1 <= 0;
            cnt100 <= 0;
        end else begin
            if (cnt100 == DIV100_COUNT) begin
                CLK_1 <= ~CLK_1;
                cnt100 <= 0;
            end else begin
                cnt100 <= cnt100 + 1;
            end
        end
    end

endmodule