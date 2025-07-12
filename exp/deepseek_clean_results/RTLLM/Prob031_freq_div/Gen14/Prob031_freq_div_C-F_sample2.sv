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
    
    // Precisely sized counters (count N/2 cycles for 50% duty cycle)
    localparam CNT_10_WIDTH = 2;  // counts 0-4 (5 cycles) needs 3 bits
    localparam CNT_1_WIDTH = 6;   // counts 0-49 (50 cycles) needs 6 bits
    localparam TERM_CNT_10 = (DIV_10/2)-1;  // 4
    localparam TERM_CNT_1 = (DIV_1/2)-1;    // 49

    // Counters
    reg [CNT_10_WIDTH-1:0] cnt10;
    reg [CNT_1_WIDTH-1:0] cnt100;

    // CLK_50 generation (divide by 2) - simplest case
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
            cnt10 <= TERM_CNT_10;
        end else begin
            if (cnt10 == 0) begin
                CLK_10 <= ~CLK_10;
                cnt10 <= TERM_CNT_10;
            end else begin
                cnt10 <= cnt10 - 1'b1;
            end
        end
    end

    // CLK_1 generation (divide by 100)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_1 <= 1'b0;
            cnt100 <= TERM_CNT_1;
        end else begin
            if (cnt100 == 0) begin
                CLK_1 <= ~CLK_1;
                cnt100 <= TERM_CNT_1;
            end else begin
                cnt100 <= cnt100 - 1'b1;
            end
        end
    end

endmodule