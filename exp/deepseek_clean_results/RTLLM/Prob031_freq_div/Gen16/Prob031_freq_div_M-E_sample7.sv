module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Stage 1: Divide by 2 (100MHz → 50MHz)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end else begin
            CLK_50 <= ~CLK_50;
        end
    end

    // Stage 2: Divide by 5 (50MHz → 10MHz)
    reg [2:0] cnt_5;  // 3-bit counter (0-4)
    
    always @(posedge CLK_50 or posedge RST) begin
        if (RST) begin
            cnt_5 <= 3'b0;
            CLK_10 <= 1'b0;
        end else begin
            if (cnt_5 == 3'd4) begin
                cnt_5 <= 3'b0;
                CLK_10 <= ~CLK_10;
            end else begin
                cnt_5 <= cnt_5 + 1'b1;
            end
        end
    end

    // Stage 3: Divide by 10 (10MHz → 1MHz)
    reg [3:0] cnt_10;  // 4-bit counter (0-9)
    
    always @(posedge CLK_10 or posedge RST) begin
        if (RST) begin
            cnt_10 <= 4'b0;
            CLK_1 <= 1'b0;
        end else begin
            if (cnt_10 == 4'd9) begin
                cnt_10 <= 4'b0;
                CLK_1 <= ~CLK_1;
            end else begin
                cnt_10 <= cnt_10 + 1'b1;
            end
        end
    end

endmodule