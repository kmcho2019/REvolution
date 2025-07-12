module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    reg [6:0] counter;  // counts 0 to 99

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            counter <= 7'd0;
            CLK_50  <= 1'b0;
            CLK_10  <= 1'b0;
            CLK_1   <= 1'b0;
        end else begin
            if (counter == 7'd99) begin
                counter <= 7'd0;
            end else begin
                counter <= counter + 7'd1;
            end

            // Toggle CLK_50 every count (divide by 2)
            if (counter[0] == 1'b1) begin
                CLK_50 <= ~CLK_50;
            end

            // Toggle CLK_10 every 5 counts: at counts 4,9,14,... (when counter % 5 == 4)
            if (counter % 7'd5 == 7'd4) begin
                CLK_10 <= ~CLK_10;
            end

            // Toggle CLK_1 every 50 counts: at counts 49 and 99
            if (counter == 7'd49 || counter == 7'd99) begin
                CLK_1 <= ~CLK_1;
            end
        end
    end

endmodule