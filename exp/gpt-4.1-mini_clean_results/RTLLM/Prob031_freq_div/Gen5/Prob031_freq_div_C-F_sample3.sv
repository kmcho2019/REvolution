module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    reg [2:0] cnt_10;    // counts 0 to 4 for divide by 10 toggle
    reg [5:0] cnt_100;   // counts 0 to 49 for divide by 100 toggle

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            // Asynchronous reset: clear outputs and counters
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1  <= 1'b0;
            cnt_10 <= 3'd0;
            cnt_100 <= 6'd0;
        end else begin
            // CLK_50: divide by 2, toggle every clock cycle
            CLK_50 <= ~CLK_50;

            // CLK_10: divide by 10
            if (cnt_10 == 3'd4) begin
                cnt_10 <= 3'd0;
                CLK_10 <= ~CLK_10;
            end else begin
                cnt_10 <= cnt_10 + 3'd1;
            end

            // CLK_1: divide by 100
            if (cnt_100 == 6'd49) begin
                cnt_100 <= 6'd0;
                CLK_1 <= ~CLK_1;
            end else begin
                cnt_100 <= cnt_100 + 6'd1;
            end
        end
    end

endmodule