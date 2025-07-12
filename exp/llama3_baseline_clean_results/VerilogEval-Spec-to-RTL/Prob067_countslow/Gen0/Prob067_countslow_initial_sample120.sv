module TopModule (
    input clk,
    input reset,
    input slowena,
    output [3:0] q
);

reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'b0000; // reset to 0
    end else if (slowena) begin
        if (count == 4'b1001) begin
            count <= 4'b0000; // wrap around to 0 after 9
        end else begin
            count <= count + 1; // increment count
        end
    end // no action when slowena is low
end

assign q = count; // output the current count

endmodule