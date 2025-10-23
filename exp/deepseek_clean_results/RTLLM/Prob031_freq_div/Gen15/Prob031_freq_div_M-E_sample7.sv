module freq_div (
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Unified counter (0-99)
    reg [6:0] counter;

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            counter <= 7'd0;
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1 <= 1'b0;
        end else begin
            // Increment counter (modulo 100)
            counter <= (counter == 7'd99) ? 7'd0 : counter + 7'd1;

            // 50MHz generation (toggle every 1 count)
            CLK_50 <= (counter[0] == 1'b0);

            // 10MHz generation (toggle every 5 counts)
            if (counter % 10 == 7'd4) CLK_10 <= 1'b1;
            else if (counter % 10 == 7'd9) CLK_10 <= 1'b0;

            // 1MHz generation (toggle every 50 counts)
            if (counter == 7'd49) CLK_1 <= 1'b1;
            else if (counter == 7'd99) CLK_1 <= 1'b0;
        end
    end

endmodule