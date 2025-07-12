module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] count;
reg [3:0] next_count;

// Combinational logic to determine the next state
always @(*) begin
    if (reset) begin
        next_count = 4'd1; // Reset to 1
    end else begin
        next_count = (count == 4'd10) ? 4'd1 : count + 1; // Simplified counter logic
    end
end

// Sequential update of the counter
always @(posedge clk) begin
    count <= next_count;
end

assign q = count;

endmodule