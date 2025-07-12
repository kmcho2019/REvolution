module freq_div (
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Shared counter for all clock divisions
    reg [6:0] shared_counter;

    always @(posedge CLK_in) begin
        if (RST) begin
            // Reset all clocks and counter
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1 <= 1'b0;
            shared_counter <= 7'd0;
        end else begin
            // Increment shared counter
            shared_counter <= (shared_counter == 7'd99) ? 7'd0 : shared_counter + 1'b1;

            // Generate 50MHz clock (toggle every cycle)
            CLK_50 <= ~CLK_50;

            // Generate 10MHz clock (toggle every 5 cycles)
            if (shared_counter[2:0] == 3'd4) begin
                CLK_10 <= ~CLK_10;
            end

            // Generate 1MHz clock (toggle every 50 cycles)
            if (shared_counter == 7'd49) begin
                CLK_1 <= ~CLK_1;
            end
        end
    end

endmodule