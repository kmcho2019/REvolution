module TopModule (
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] count;
reg [3:0] next_count;

// Increment the count
always @(*) begin
    next_count = count + 1;
    if (next_count == 4'd11) begin
        next_count = 4'd1;
    end
    if (reset) begin
        next_count = 4'd1;
    end
end

// Sequential logic to update state
always @(posedge clk) begin
    count <= next_count;
end

// Directly assign count to output
assign q = count;

endmodule