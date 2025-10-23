module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Unified counter for all clock divisions
    reg [6:0] counter; // Counts 0-99 (7 bits for safety)

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            counter <= 7'd0;
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1 <= 1'b0;
        end
        else begin
            // Update counter (modulo 100)
            counter <= (counter == 7'd99) ? 7'd0 : counter + 1'b1;

            // CLK_50: toggle every cycle (divide by 2)
            CLK_50 <= ~CLK_50;

            // CLK_10: toggle every 5 cycles (divide by 10)
            if (counter[1:0] == 2'b00) begin
                CLK_10 <= ~CLK_10;
            end

            // CLK_1: toggle every 100 cycles (divide by 100)
            if (counter == 7'd0) begin
                CLK_1 <= ~CLK_1;
            end
        end
    end

endmodule