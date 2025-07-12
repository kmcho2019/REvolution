module TopModule(
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] count = 1; // Initialize count to 1

always @(posedge clk) begin
    if (reset) begin // If reset is high, reset count to 1
        count <= 4'd1; // 'd' is used to specify decimal number
    end else if (count == 10) begin // If count reaches 10, reset it to 1
        count <= 4'd1;
    end else begin // Otherwise, increment the count
        count <= count + 1;
    end
end

assign q = count; // Assign the count to output q

endmodule