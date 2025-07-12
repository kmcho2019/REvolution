module freq_div (
    input CLK_in,
    input RST,
    output wire CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Combined counter (7 bits for counting up to 99)
    reg [6:0] counter;

    // CLK_50 generation using continuous assignment (divide by 2)
    assign CLK_50 = counter[0]; // LSB toggles at 50MHz

    // Combined counter logic
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            counter <= 7'b0;
            CLK_10 <= 1'b0;
            CLK_1 <= 1'b0;
        end else begin
            // Increment counter, wrapping at 99
            counter <= (counter == 7'd99) ? 7'b0 : counter + 7'b1;

            // CLK_10 generation (toggle every 5 counter cycles)
            if (counter % 10 == 4) begin
                CLK_10 <= ~CLK_10;
            end

            // CLK_1 generation (toggle every 50 counter cycles)
            if (counter == 7'd49) begin
                CLK_1 <= ~CLK_1;
            end
        end
    end

endmodule