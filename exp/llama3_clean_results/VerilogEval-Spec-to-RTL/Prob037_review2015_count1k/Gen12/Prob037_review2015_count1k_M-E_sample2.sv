module TopModule(
    input clk,
    input reset,
    output [9:0] q
);

reg [4:0] counter1; // First 5-bit counter
reg [4:0] counter2; // Second 5-bit counter
wire [9:0] count_out; // Output of the counter combination

always @(posedge clk) begin
    if (reset) begin
        counter1 <= 5'd0;
        counter2 <= 5'd0;
    end else begin
        if (counter1 == 5'd31) begin
            counter1 <= 5'd0;
            counter2 <= counter2 + 5'd1;
        end else begin
            counter1 <= counter1 + 5'd1;
        end
    end
end

assign count_out = {counter2, counter1}; // Combine the two counters to form the 10-bit output
assign q = (count_out > 10'd999) ? 10'd999 : count_out; // Limit the output to 999

endmodule