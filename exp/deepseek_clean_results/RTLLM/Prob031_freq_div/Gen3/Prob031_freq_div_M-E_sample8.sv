module freq_div (
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Shared counter (0-99)
    reg [6:0] shared_counter;

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            shared_counter <= 7'd0;
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1 <= 1'b0;
        end else begin
            // Update shared counter
            if (shared_counter == 7'd99) begin
                shared_counter <= 7'd0;
            end else begin
                shared_counter <= shared_counter + 7'd1;
            end

            // CLK_50 - toggle every cycle (divide by 2)
            CLK_50 <= ~CLK_50;

            // CLK_10 - toggle every 10 counts (divide by 10)
            if (shared_counter % 7'd10 == 7'd0) begin
                CLK_10 <= ~CLK_10;
            end

            // CLK_1 - toggle every 100 counts (divide by 100)
            if (shared_counter == 7'd0) begin
                CLK_1 <= ~CLK_1;
            end
        end
    end

endmodule