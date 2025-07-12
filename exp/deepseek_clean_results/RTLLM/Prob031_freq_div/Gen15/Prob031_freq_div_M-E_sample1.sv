module freq_div (
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Stage 1: 50MHz generation (divide by 2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 0;
        end else begin
            CLK_50 <= ~CLK_50;
        end
    end

    // Stage 2: 10MHz generation (divide by 10)
    reg [2:0] cnt_10;
    wire en_10 = (cnt_10 == 3'd4);
    
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_10 <= 0;
            CLK_10 <= 0;
        end else begin
            if (CLK_50) begin  // Only count at 50MHz rate
                if (en_10) begin
                    cnt_10 <= 0;
                    CLK_10 <= ~CLK_10;
                end else begin
                    cnt_10 <= cnt_10 + 1;
                end
            end
        end
    end

    // Stage 3: 1MHz generation (divide by 100)
    reg [3:0] cnt_100;
    wire en_1 = (cnt_100 == 4'd9);
    
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_100 <= 0;
            CLK_1 <= 0;
        end else begin
            if (en_10) begin  // Only count at 10MHz rate
                if (en_1) begin
                    cnt_100 <= 0;
                    CLK_1 <= ~CLK_1;
                end else begin
                    cnt_100 <= cnt_100 + 1;
                end
            end
        end
    end

endmodule