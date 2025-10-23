module freq_div (
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // 50MHz generation (div-by-2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end else begin
            CLK_50 <= ~CLK_50;
        end
    end

    // 10MHz generation (div-by-5 from 50MHz)
    reg [1:0] cnt5;
    always @(posedge CLK_50 or posedge RST) begin
        if (RST) begin
            CLK_10 <= 1'b0;
            cnt5 <= 2'd0;
        end else begin
            if (cnt5 == 2'd4) begin
                CLK_10 <= ~CLK_10;
                cnt5 <= 2'd0;
            end else begin
                cnt5 <= cnt5 + 2'd1;
            end
        end
    end

    // 1MHz generation (div-by-10 from 10MHz)
    reg [2:0] cnt10;
    always @(posedge CLK_10 or posedge RST) begin
        if (RST) begin
            CLK_1 <= 1'b0;
            cnt10 <= 3'd0;
        end else begin
            if (cnt10 == 3'd9) begin
                CLK_1 <= ~CLK_1;
                cnt10 <= 3'd0;
            end else begin
                cnt10 <= cnt10 + 3'd1;
            end
        end
    end

endmodule