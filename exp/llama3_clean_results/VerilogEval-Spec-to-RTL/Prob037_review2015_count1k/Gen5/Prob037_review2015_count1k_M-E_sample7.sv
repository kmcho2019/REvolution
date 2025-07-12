module TopModule(
    input clk,
    input reset,
    output reg [9:0] q
);

reg [3:0] ones_counter;  // Counts from 0 to 9
reg [6:0] tens_hundreds_counter;  // Counts from 0 to 99

always @(posedge clk) begin
    if (reset) begin
        ones_counter <= 0;
        tens_hundreds_counter <= 0;
    end else begin
        if (ones_counter == 4'd9) begin
            ones_counter <= 0;
            if (tens_hundreds_counter == 7'd99) begin
                tens_hundreds_counter <= 0;
            end else begin
                tens_hundreds_counter <= tens_hundreds_counter + 1;
            end
        end else begin
            ones_counter <= ones_counter + 1;
        end
    end
end

always @(*) begin
    q = {tens_hundreds_counter, ones_counter};
end

endmodule