module freq_div (
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    reg [5:0] cnt_10;  // Needs to count up to 4 (3 bits would suffice)
    reg [6:0] cnt_100; // Needs to count up to 49 (6 bits would suffice)

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
            cnt_10 <= 6'd0;
        end else begin
            if (cnt_10 == 6'd4) begin
                CLK_10 <= ~CLK_10;
                cnt_10 <= 6'd0;
            end else begin
                cnt_10 <= cnt_10 + 6'd1;
            end
        end
    end

    // CLK_1 generation (divide by 100)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_1 <= 1'b0;
            cnt_100 <= 7'd0;
        end else begin
            if (cnt_100 == 7'd49) begin
                CLK_1 <= ~CLK_1;
                cnt_100 <= 7'd0;
            end else begin
                cnt_100 <= cnt_100 + 7'd1;
            end
        end
    end

endmodule