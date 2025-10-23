module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    reg [0:0] cnt_2;
    reg [3:0] cnt_10;
    reg [6:0] cnt_100;

    always @(posedge CLK_in) begin
        if (RST) begin
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1  <= 1'b0;
            cnt_2  <= 1'd1;     // reload value for divide by 2 (toggle on zero)
            cnt_10 <= 4'd4;    // reload value for divide by 10 (toggle on zero)
            cnt_100 <= 7'd49;  // reload value for divide by 100 (toggle on zero)
        end else begin
            // CLK_50 division by 2
            if (cnt_2 == 0) begin
                CLK_50 <= ~CLK_50;
                cnt_2 <= 1'd1;
            end else begin
                cnt_2 <= cnt_2 - 1'b1;
            end

            // CLK_10 division by 10
            if (cnt_10 == 0) begin
                CLK_10 <= ~CLK_10;
                cnt_10 <= 4'd4;
            end else begin
                cnt_10 <= cnt_10 - 1'b1;
            end

            // CLK_1 division by 100
            if (cnt_100 == 0) begin
                CLK_1 <= ~CLK_1;
                cnt_100 <= 7'd49;
            end else begin
                cnt_100 <= cnt_100 - 1'b1;
            end
        end
    end

endmodule