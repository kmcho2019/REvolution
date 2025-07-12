module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    reg [2:0] cnt_10;    // Counter for divide by 10 (toggle at count 4)
    reg [5:0] cnt_100;   // Counter for divide by 100 (toggle at count 49)

    // Clock enable signals for counters to reduce toggling
    wire ce_10 = 1'b1;    // always enabled since counting every cycle
    wire ce_100 = 1'b1;   // always enabled since counting every cycle

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50  <= 1'b0;
            CLK_10  <= 1'b0;
            CLK_1   <= 1'b0;
            cnt_10  <= 3'd0;
            cnt_100 <= 6'd0;
        end else begin
            // Divide by 2: toggle every cycle (cannot gate)
            CLK_50 <= ~CLK_50;

            // Divide by 10: counter increments only when enabled
            if (ce_10) begin
                if (cnt_10 == 3'd4) begin
                    CLK_10 <= ~CLK_10;
                    cnt_10 <= 3'd0;
                end else begin
                    cnt_10 <= cnt_10 + 1'b1;
                end
            end

            // Divide by 100: counter increments only when enabled
            if (ce_100) begin
                if (cnt_100 == 6'd49) begin
                    CLK_1 <= ~CLK_1;
                    cnt_100 <= 6'd0;
                end else begin
                    cnt_100 <= cnt_100 + 1'b1;
                end
            end
        end
    end

endmodule