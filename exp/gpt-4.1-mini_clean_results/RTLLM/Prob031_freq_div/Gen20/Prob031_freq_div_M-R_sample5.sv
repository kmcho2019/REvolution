module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Parameters for half-period counts
    localparam HALF_PERIOD_10  = 5 - 1;   // toggle every 5 CLK_in cycles
    localparam HALF_PERIOD_100 = 50 - 1;  // toggle every 50 CLK_in cycles

    reg [2:0]  cnt_10;
    reg [5:0]  cnt_100;

    always @(posedge CLK_in) begin
        if (RST) begin
            // Synchronous reset
            CLK_50  <= 1'b0;
            CLK_10  <= 1'b0;
            CLK_1   <= 1'b0;
            cnt_10  <= 3'd0;
            cnt_100 <= 6'd0;
        end else begin
            // CLK_50 toggle every clock cycle (divide by 2)
            CLK_50 <= ~CLK_50;

            // CLK_10 generation
            if (cnt_10 == HALF_PERIOD_10) begin
                cnt_10 <= 3'd0;
                CLK_10 <= ~CLK_10;
            end else begin
                cnt_10 <= cnt_10 + 1'b1;
            end

            // CLK_1 generation
            if (cnt_100 == HALF_PERIOD_100) begin
                cnt_100 <= 6'd0;
                CLK_1 <= ~CLK_1;
            end else begin
                cnt_100 <= cnt_100 + 1'b1;
            end
        end
    end

endmodule