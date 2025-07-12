module freq_div (
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Unified counter (0-99) for all clock divisions
    reg [6:0] counter;

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            counter <= 7'd0;
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1 <= 1'b0;
        end else begin
            // Update counter (roll over at 99)
            counter <= (counter == 7'd99) ? 7'd0 : counter + 7'd1;
            
            // CLK_50: toggle every cycle (using LSB)
            CLK_50 <= ~CLK_50;
            
            // CLK_10: toggle when lower 3 bits match pattern (every 5 cycles)
            if (counter[2:0] == 3'b100) begin
                CLK_10 <= ~CLK_10;
            end
            
            // CLK_1: toggle at counter == 49 (every 50 cycles)
            if (counter == 7'd49) begin
                CLK_1 <= ~CLK_1;
            end
        end
    end

endmodule