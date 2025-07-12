module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Counters
    reg [3:0] cnt_10;  // 4-bit counter for 10MHz (counts 0-4)
    reg [6:0] cnt_100; // 7-bit counter for 1MHz (counts 0-49)

    // CLK_50 generation (divide by 2)
    always @(posedge CLK_in) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end else begin
            CLK_50 <= ~CLK_50;
        end
    end

    // CLK_10 generation (divide by 10)
    always @(posedge CLK_in) begin
        if (RST) begin
            CLK_10 <= 1'b0;
            cnt_10 <= 4'd0;
        end else begin
            if (cnt_10 == 4'd4) begin
                CLK_10 <= ~CLK_10;
                cnt_10 <= 4'd0;
            end else begin
                cnt_10 <= cnt_10 + 4'd1;
            end
        end
    end

    // CLK_1 generation (divide by 100)
    always @(posedge CLK_in) begin
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