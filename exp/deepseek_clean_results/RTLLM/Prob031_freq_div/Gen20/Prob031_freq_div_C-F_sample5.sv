module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Division parameters with validation
    parameter DIV_50 = 2;     // 100MHz / 2 = 50MHz (must be even)
    parameter DIV_10 = 10;    // 100MHz / 10 = 10MHz (must be even)
    parameter DIV_1 = 100;    // 100MHz / 100 = 1MHz (must be even)

    // Validate parameters at elaboration
    initial begin
        if (DIV_50 % 2 != 0 || DIV_10 % 2 != 0 || DIV_1 % 2 != 0) begin
            $error("All division ratios must be even numbers");
            $finish;
        end
    end

    // Counter limits (half periods)
    localparam LIM_50 = (DIV_50/2)-1;
    localparam LIM_10 = (DIV_10/2)-1;
    localparam LIM_1 = (DIV_1/2)-1;
    
    // Counter widths with range checking
    localparam W_50 = (DIV_50 > 2) ? $clog2(DIV_50/2) : 1;
    localparam W_10 = (DIV_10 > 2) ? $clog2(DIV_10/2) : 1;
    localparam W_1 = (DIV_1 > 2) ? $clog2(DIV_1/2) : 1;

    // Counters
    reg [W_50-1:0] cnt_50;
    reg [W_10-1:0] cnt_10;
    reg [W_1-1:0] cnt_1;
    
    // Clock enables
    wire clk_50_en = (cnt_50 == 0);
    wire clk_10_en = (cnt_10 == 0);
    wire clk_1_en = (cnt_1 == 0);

    // CLK_50 generation (divide by DIV_50)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
            cnt_50 <= LIM_50;
        end else begin
            if (clk_50_en) begin
                CLK_50 <= ~CLK_50;
                cnt_50 <= LIM_50;
            end else begin
                cnt_50 <= cnt_50 - 1'b1;
            end
        end
    end

    // CLK_10 generation (divide by DIV_10)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_10 <= 1'b0;
            cnt_10 <= LIM_10;
        end else begin
            if (clk_10_en) begin
                CLK_10 <= ~CLK_10;
                cnt_10 <= LIM_10;
            end else begin
                cnt_10 <= cnt_10 - 1'b1;
            end
        end
    end

    // CLK_1 generation (divide by DIV_1)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_1 <= 1'b0;
            cnt_1 <= LIM_1;
        end else begin
            if (clk_1_en) begin
                CLK_1 <= ~CLK_1;
                cnt_1 <= LIM_1;
            end else begin
                cnt_1 <= cnt_1 - 1'b1;
            end
        end
    end

endmodule