module freq_div (
    input CLK_in,
    input RST,
    output wire CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // CLK_50 generation (divide by 2) - simple toggle flip-flop
    reg clk_50_reg;
    assign CLK_50 = clk_50_reg;
    
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            clk_50_reg <= 1'b0;
        end else begin
            clk_50_reg <= ~clk_50_reg;
        end
    end

    // CLK_10 generation (divide by 10)
    reg [2:0] cnt_10;
    
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_10 <= 1'b0;
            cnt_10 <= 3'b0;
        end else begin
            if (cnt_10 == 3'd4) begin  // Toggle at count 4 (5th cycle)
                CLK_10 <= ~CLK_10;
                cnt_10 <= 3'b0;
            end else begin
                cnt_10 <= cnt_10 + 1'b1;
            end
        end
    end

    // CLK_1 generation (divide by 100)
    reg [5:0] cnt_100;
    
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_1 <= 1'b0;
            cnt_100 <= 6'b0;
        end else begin
            if (cnt_100 == 6'd49) begin  // Toggle at count 49 (50th cycle)
                CLK_1 <= ~CLK_1;
                cnt_100 <= 6'b0;
            end else begin
                cnt_100 <= cnt_100 + 1'b1;
            end
        end
    end

endmodule