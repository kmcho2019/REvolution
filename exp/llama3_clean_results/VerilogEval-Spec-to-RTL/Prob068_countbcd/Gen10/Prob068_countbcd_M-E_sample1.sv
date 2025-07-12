module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

reg [15:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 16'd0;
    end else begin
        // Increment the count
        count <= count + 1;
        
        // Apply BCD wrapping for each digit
        if (count[3:0] > 4'd9) begin
            count[3:0] <= 4'd0;
        end
        if (count[7:4] > 4'd9 && count[3:0] == 4'd0) begin
            count[7:4] <= 4'd0;
        end
        if (count[11:8] > 4'd9 && count[7:4] == 4'd0 && count[3:0] == 4'd0) begin
            count[11:8] <= 4'd0;
        end
        if (count[15:12] > 4'd9 && count[11:8] == 4'd0 && count[7:4] == 4'd0 && count[3:0] == 4'd0) begin
            count[15:12] <= 4'd0;
        end
    end
end

// Assign outputs
assign q = count;

// Generate enable signals based on the current count
assign ena[0] = (count[3:0] == 4'd9) ? 1'b1 : 1'b0;
assign ena[1] = (count[7:4] == 4'd9 && count[3:0] == 4'd0) ? 1'b1 : 1'b0;
assign ena[2] = (count[11:8] == 4'd9 && count[7:4] == 4'd0 && count[3:0] == 4'd0) ? 1'b1 : 1'b0;

endmodule