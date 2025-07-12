module TopModule (
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] count;

initial count = 3'b100;  // Initialize count to 4 (100 in binary)

always @(posedge clk) begin
    if (~a) begin
        count <= count + 1;
        if (count == 4'b1000) begin  // Check for overflow
            count <= 3'b000;  // Reset to 0 if count overflows
        end
    end else begin
        count <= 3'b100;  // Reset to 4 if 'a' is high
    end
end

assign q = count;

endmodule