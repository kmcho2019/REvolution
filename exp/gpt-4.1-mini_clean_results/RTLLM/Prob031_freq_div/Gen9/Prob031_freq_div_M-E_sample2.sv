module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // For 50 MHz: divide by 2 => half period count = 1
    reg cnt_2;

    // For 10 MHz: divide by 10 => half period count = 5
    reg [2:0] cnt_10;

    // For 1 MHz: divide by 100 => half period count = 50
    reg [6:0] cnt_100;

    // CLK_50 generation: toggle every 1 count (divide by 2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_2 <= 1'b0;
            CLK_50 <= 1'b0;
        end else begin
            if (cnt_2 == 1'b1) begin
                cnt_2 <= 1'b0;
                CLK_50 <= ~CLK_50;
            end else begin
                cnt_2 <= cnt_2 + 1'b1;
            end
        end
    end

    // CLK_10 generation: toggle every 5 counts (divide by 10)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_10 <= 3'd0;
            CLK_10 <= 1'b0;
        end else begin
            if (cnt_10 == 3'd4) begin
                cnt_10 <= 3'd0;
                CLK_10 <= ~CLK_10;
            end else begin
                cnt_10 <= cnt_10 + 1'b1;
            end
        end
    end

    // CLK_1 generation: toggle every 50 counts (divide by 100)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_100 <= 7'd0;
            CLK_1 <= 1'b0;
        end else begin
            if (cnt_100 == 7'd49) begin
                cnt_100 <= 7'd0;
                CLK_1 <= ~CLK_1;
            end else begin
                cnt_100 <= cnt_100 + 1'b1;
            end
        end
    end

endmodule