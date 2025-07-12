module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Constants for division ratios
    localparam DIV_50 = 1;      // Divide by 2 (toggle every cycle)
    localparam DIV_10 = 4;      // Divide by 10 (count 0-4)
    localparam DIV_1 = 9;       // Divide by 10 of CLK_10 (count 0-9)

    // Counter for 10MHz clock (divide by 10)
    reg [2:0] cnt_10;
    
    // Counter for 1MHz clock (divide by 10 of CLK_10)
    reg [3:0] cnt_1;

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
            cnt_10 <= DIV_10;
        end else begin
            if (cnt_10 == 0) begin
                CLK_10 <= ~CLK_10;
                cnt_10 <= DIV_10;
            end else begin
                cnt_10 <= cnt_10 - 1'b1;
            end
        end
    end

    // CLK_1 generation (divide CLK_10 by 10)
    always @(posedge CLK_10 or posedge RST) begin
        if (RST) begin
            CLK_1 <= 1'b0;
            cnt_1 <= DIV_1;
        end else begin
            if (cnt_1 == 0) begin
                CLK_1 <= ~CLK_1;
                cnt_1 <= DIV_1;
            end else begin
                cnt_1 <= cnt_1 - 1'b1;
            end
        end
    end

endmodule