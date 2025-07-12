module freq_div (
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Single 7-bit counter (0-99)
    reg [6:0] cnt;

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt <= 7'b0;
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1 <= 1'b0;
        end else begin
            cnt <= (cnt == 7'd99) ? 7'b0 : cnt + 1'b1;
            
            // CLK_50: toggle every cycle (MSB of counter)
            CLK_50 <= cnt[6];
            
            // CLK_10: toggle every 5 cycles (bit 3 of counter)
            CLK_10 <= cnt[3];
            
            // CLK_1: toggle every 50 cycles (when counter wraps)
            CLK_1 <= (cnt == 7'd49);
        end
    end

endmodule