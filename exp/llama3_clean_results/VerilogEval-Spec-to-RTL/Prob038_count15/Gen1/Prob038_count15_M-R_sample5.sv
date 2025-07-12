module TopModule(
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] count = 4'b0000; // Using initial value

always @(posedge clk) begin
    if (reset) begin
        count <= #0 4'b0000; // Using non-blocking assignment with delay
    end else begin
        if (count == 4'b1111) begin
            count <= #0 4'b0000;
        end else begin
            count <= #0 count + 1'b1;
        end
    end
end

assign q = count;

endmodule