module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

// Use a reg to hold the count value
reg [3:0] count;

// Always block to handle the counter logic
always @(posedge clk) begin
    // If reset is high, reset the counter
    if (reset) begin
        count <= 4'd0;
    end else if (count == 4'd9) begin
        // If count reaches 9, reset it to 0
        count <= 4'd0;
    end else begin
        // Otherwise, increment the counter
        count <= count + 4'd1;
    end
end

// Direct assignment for efficiency
assign q = count;

endmodule