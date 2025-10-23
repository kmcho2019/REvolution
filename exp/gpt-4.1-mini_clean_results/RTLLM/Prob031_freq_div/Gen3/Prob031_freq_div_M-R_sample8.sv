module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    reg [2:0] cnt_10;    // Counts 0 to 4 for divide by 10 (toggle every 5 cycles)
    reg [5:0] cnt_100;   // Counts 0 to 49 for divide by 100 (toggle every 50 cycles)
    reg cnt_2;           // Toggle bit for divide by 2 (CLK_50)

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_2   <= 1'b0;
            CLK_50  <= 1'b0;
            cnt_10  <= 3'd0;
            CLK_10  <= 1'b0;
            cnt_100 <= 6'd0;
            CLK_1   <= 1'b0;
        end else begin
            // Divide by 2
            cnt_2 <= ~cnt_2;
            CLK_50 <= cnt_2;

            // Divide by 10
            if (cnt_10 == 3'd4) begin
                cnt_10 <= 3'd0;
                CLK_10 <= ~CLK_10;
            end else begin
                cnt_10 <= cnt_10 + 1'b1;
            end

            // Divide by 100
            if (cnt_100 == 6'd49) begin
                cnt_100 <= 6'd0;
                CLK_1 <= ~CLK_1;
            end else begin
                cnt_100 <= cnt_100 + 1'b1;
            end
        end
    end

endmodule