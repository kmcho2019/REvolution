module freq_div (
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Unified counter for all clock divisions
    reg [6:0] counter;

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            counter <= 7'b0;
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1 <= 1'b0;
        end
        else begin
            // Increment the unified counter
            counter <= (counter == 7'd99) ? 7'b0 : counter + 1'b1;

            // CLK_50 generation (divide by 2) - toggle every cycle
            CLK_50 <= ~CLK_50;

            // CLK_10 generation (divide by 10)
            if (counter[2:0] == 3'b100) begin
                CLK_10 <= ~CLK_10;
            end

            // CLK_1 generation (divide by 100)
            if (counter == 7'd49) begin
                CLK_1 <= ~CLK_1;
            end
        end
    end

endmodule