module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Unified counter for all clock divisions
    reg [6:0] unified_counter;

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            unified_counter <= 7'b0;
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1 <= 1'b0;
        end
        else begin
            // Increment unified counter (rolls over automatically at 100)
            unified_counter <= unified_counter + 1'b1;
            
            // Generate CLK_50 from LSB (toggles every cycle)
            CLK_50 <= unified_counter[0];
            
            // Generate CLK_10 from bit 2 (toggles every 5 cycles)
            CLK_10 <= unified_counter[2];
            
            // Generate CLK_1 from MSB (toggles every 50 cycles)
            CLK_1 <= unified_counter[6];
        end
    end

endmodule