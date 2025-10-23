module freq_div (
    input wire CLK_in,
    input wire RST,
    output wire CLK_50,
    output wire CLK_10,
    output wire CLK_1
);

    // Parameters for maintainability
    parameter DIV_50 = 2;
    parameter DIV_10 = 10;
    
    // CLK_50 generation (divide by 2)
    reg clk_50_reg;
    always @(posedge CLK_in or posedge RST) begin
        if (RST) clk_50_reg <= 1'b0;
        else clk_50_reg <= ~clk_50_reg;
    end
    assign CLK_50 = clk_50_reg;

    // CLK_10 generation (divide by 10) with Gray code counter
    reg [2:0] cnt_10_gray;
    reg clk_10_reg;
    wire [2:0] next_cnt_10_gray;
    
    // Gray code sequence: 000, 001, 011, 010, 110, 111, 101, 100, 000...
    assign next_cnt_10_gray = (cnt_10_gray == 3'b100) ? 3'b000 : 
                             (cnt_10_gray == 3'b000) ? 3'b001 :
                             (cnt_10_gray == 3'b001) ? 3'b011 :
                             (cnt_10_gray == 3'b011) ? 3'b010 :
                             (cnt_10_gray == 3'b010) ? 3'b110 :
                             (cnt_10_gray == 3'b110) ? 3'b111 :
                             (cnt_10_gray == 3'b111) ? 3'b101 : 3'b100;
    
    wire clk_10_en = (cnt_10_gray == 3'b100);
    
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_10_gray <= 3'b000;
            clk_10_reg <= 1'b0;
        end
        else begin
            cnt_10_gray <= next_cnt_10_gray;
            if (clk_10_en) begin
                clk_10_reg <= ~clk_10_reg;
            end
        end
    end
    assign CLK_10 = clk_10_reg;

    // CLK_1 generation using cascaded 10×10 dividers
    reg [3:0] cnt_100;
    reg clk_1_reg;
    wire clk_1_en;
    
    // First stage (divide by 10)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_100[1:0] <= 2'b00;
        end
        else if (cnt_100[1:0] == 2'b10) begin  // Count 3 cycles (0-2)
            cnt_100[1:0] <= 2'b00;
        end
        else begin
            cnt_100[1:0] <= cnt_100[1:0] + 1'b1;
        end
    end
    
    // Second stage (divide by 10)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_100[3:2] <= 2'b00;
            clk_1_reg <= 1'b0;
        end
        else if (cnt_100[1:0] == 2'b10) begin
            if (cnt_100[3:2] == 2'b10) begin  // Count 3 cycles (0-2)
                cnt_100[3:2] <= 2'b00;
                clk_1_reg <= ~clk_1_reg;
            end
            else begin
                cnt_100[3:2] <= cnt_100[3:2] + 1'b1;
            end
        end
    end
    assign CLK_1 = clk_1_reg;

endmodule