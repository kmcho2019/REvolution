module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q_reg;

always @(posedge clk) begin
    if (reset) begin
        q_reg <= 8'd52; // 0x34 in decimal is 52
    end else begin
        q_reg <= d;
    end
end

assign q = ~clk ? d : q_reg;

// to trigger at negative edge, we need to use a single always block
// for a falling edge we can assign the value to output before the next
// positive edge, using the previous value
// since the d value must be captured at negative edge and output at 
// negative edge, it can be directly assigned at that instance itself.
// to capture d at negative edge and output at positive edge we need 
// to store d at negative edge. For this reason a reg is needed.
// So the correct approach here would be 
always @(negedge clk) begin
    if (reset) begin
        q_reg <= 8'd52; // 0x34 in decimal is 52
    end else begin
        q_reg <= d;
    end
end

assign q = q_reg;

endmodule