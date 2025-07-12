module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Counter for 10MHz clock (divide by 10)
    reg [3:0] cnt_10;
    
    // Counter for 1MHz clock (divide by 10 from CLK_10)
    reg [3:0] cnt_1;

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            // Reset all clocks and counters
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1 <= 1'b0;
            cnt_10 <= 4'b0;
            cnt_1 <= 4'b0;
        end
        else begin
            // CLK_50 generation (divide by 2)
            CLK_50 <= ~CLK_50;
            
            // CLK_10 generation (divide by 10)
            if (cnt_10 == 4'd9) begin
                CLK_10 <= ~CLK_10;
                cnt_10 <= 4'b0;
            end
            else begin
                cnt_10 <= cnt_10 + 1'b1;
            end
        end
    end

    // CLK_1 generation from CLK_10 (divide by 10)
    always @(posedge CLK_10 or posedge RST) begin
        if (RST) begin
            CLK_1 <= 1'b0;
            cnt_1 <= 4'b0;
        end
        else begin
            if (cnt_1 == 4'd9) begin
                CLK_1 <= ~CLK_1;
                cnt_1 <= 4'b0;
            end
            else begin
                cnt_1 <= cnt_1 + 1'b1;
            end
        end
    end

endmodule