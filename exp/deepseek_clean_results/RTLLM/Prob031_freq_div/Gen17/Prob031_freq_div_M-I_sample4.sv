module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Parameters for division factors
    parameter DIV_50 = 2;
    parameter DIV_10 = 5;   // Now relative to 50MHz
    parameter DIV_1 = 10;   // Now relative to 10MHz
    
    // Pre-calculated terminal counts
    localparam TERM_50 = DIV_50 - 1;
    localparam TERM_10 = DIV_10 - 1;
    localparam TERM_1 = DIV_1 - 1;

    // Shared counter for all clocks
    reg [2:0] cnt_50 = 0;
    reg [2:0] cnt_10 = 0;
    reg [3:0] cnt_1 = 0;

    // CLK_50 generation (divide by 2)
    always @(posedge CLK_in) begin
        if (RST) begin
            CLK_50 <= 1'b0;
            cnt_50 <= 0;
        end else begin
            if (cnt_50 == TERM_50) begin
                CLK_50 <= ~CLK_50;
                cnt_50 <= 0;
            end else begin
                cnt_50 <= cnt_50 + 1'b1;
            end
        end
    end

    // CLK_10 generation (divide by 5 from 50MHz)
    always @(posedge CLK_50) begin
        if (RST) begin
            CLK_10 <= 1'b0;
            cnt_10 <= 0;
        end else begin
            if (cnt_10 == TERM_10) begin
                CLK_10 <= ~CLK_10;
                cnt_10 <= 0;
            end else begin
                cnt_10 <= cnt_10 + 1'b1;
            end
        end
    end

    // CLK_1 generation (divide by 10 from 10MHz)
    always @(posedge CLK_10) begin
        if (RST) begin
            CLK_1 <= 1'b0;
            cnt_1 <= 0;
        end else begin
            if (cnt_1 == TERM_1) begin
                CLK_1 <= ~CLK_1;
                cnt_1 <= 0;
            end else begin
                cnt_1 <= cnt_1 + 1'b1;
            end
        end
    end

endmodule