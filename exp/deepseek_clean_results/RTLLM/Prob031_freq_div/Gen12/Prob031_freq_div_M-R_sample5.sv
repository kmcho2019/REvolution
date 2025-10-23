module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Division ratios
    localparam DIV_50 = 2;    // 100MHz / 2 = 50MHz
    localparam DIV_10 = 10;   // 100MHz / 10 = 10MHz
    localparam DIV_1  = 100;  // 100MHz / 100 = 1MHz
    
    // Counter widths (log2 of division ratio)
    localparam W_10 = $clog2(DIV_10/2);
    localparam W_1  = $clog2(DIV_1/2);
    
    // Counter for 10MHz clock (divide by 10)
    reg [W_10-1:0] cnt_10;
    
    // Counter for 1MHz clock (divide by 100)
    reg [W_1-1:0] cnt_1;

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
            cnt_10 <= (DIV_10/2)-1;  // Initialize to count-1 (down counter)
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
            cnt_1 <= (DIV_1/2)-1;  // Initialize to count-1 (down counter)
        end else begin
            if (cnt_1 == 0) begin
                CLK_1 <= ~CLK_1;
                cnt_1 <= (DIV_1/2)-1;
            end else begin
                cnt_1 <= cnt_1 - 1'b1;
            end
        end
    end

endmodule