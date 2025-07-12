module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Parameters define half-period counts for toggling outputs
    parameter HALF_PERIOD_10  = 5 - 1;   // Toggle every 5 clock cycles (divide by 10)
    parameter HALF_PERIOD_100 = 50 - 1;  // Toggle every 50 clock cycles (divide by 100)

    reg [2:0]  cnt_10;    // 3-bit counter (0 to 4)
    reg [5:0]  cnt_100;   // 6-bit counter (0 to 49)

    // CLK_50 generation: simply divide by 2 using flip-flop triggered by CLK_in
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end else begin
            CLK_50 <= ~CLK_50;
        end
    end

    // CLK_10 generation
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_10 <= 3'd0;
            CLK_10 <= 1'b0;
        end else begin
            if (cnt_10 == HALF_PERIOD_10) begin
                cnt_10 <= 3'd0;
                CLK_10 <= ~CLK_10;
            end else begin
                cnt_10 <= cnt_10 + 1'b1;
            end
        end
    end

    // CLK_1 generation
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_100 <= 6'd0;
            CLK_1 <= 1'b0;
        end else begin
            if (cnt_100 == HALF_PERIOD_100) begin
                cnt_100 <= 6'd0;
                CLK_1 <= ~CLK_1;
            end else begin
                cnt_100 <= cnt_100 + 1'b1;
            end
        end
    end

endmodule