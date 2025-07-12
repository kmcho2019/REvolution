module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    reg [3:0] units, tens, hundreds;

    // Counting logic for each digit
    always @(posedge clk) begin
        if (reset) begin
            units   <= 4'd0;
            tens    <= 4'd0;
            hundreds <= 4'd0;
            q       <= 10'd0;
        end else begin
            if (units == 4'd9) begin
                units <= 4'd0;
                if (tens == 4'd9) begin
                    tens <= 4'd0;
                    if (hundreds == 4'd9) begin
                        hundreds <= 4'd0;
                        q <= 10'd0;
                    end else begin
                        hundreds <= hundreds + 1'b1;
                        q <= (hundreds + 1) * 100 + 0 * 10 + 0; // hundreds incremented, tens and units zeroed
                    end
                end else begin
                    tens <= tens + 1'b1;
                    q <= hundreds * 100 + (tens + 1) * 10 + 0; // tens incremented, units zeroed
                end
            end else begin
                units <= units + 1'b1;
                q <= hundreds * 100 + tens * 10 + (units + 1);
            end
        end
    end

endmodule