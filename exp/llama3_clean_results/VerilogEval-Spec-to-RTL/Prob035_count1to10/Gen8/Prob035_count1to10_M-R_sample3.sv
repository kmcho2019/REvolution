module TopModule (
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'd1; // Reset count to 1
    end else if (count == 4'd10) begin
        count <= 4'd1; // Wrap around to 1 after 10
    end else begin
        count <= count + 1; // Increment count by 1
    end
end

assign q = count;

// Alternative implementation using a modulo operation
// always @(posedge clk) begin
//     if (reset) begin
//         count <= 4'd1; // Reset count to 1
//     end else begin
//         count <= (count == 4'd10) ? 4'd1 : count + 1; // Increment count by 1, wrap around to 1 after 10
//     end
// end

// Using a combination of combinational and sequential logic
// reg [3:0] next_count;
// always @(*) begin
//     if (count == 4'd10) begin
//         next_count = 4'd1; // Wrap around to 1 after 10
//     end else begin
//         next_count = count + 1; // Increment count by 1
//     end
// end

// always @(posedge clk) begin
//     if (reset) begin
//         count <= 4'd1; // Reset count to 1
//     end else begin
//         count <= next_count; // Update count
//     end
// end

endmodule