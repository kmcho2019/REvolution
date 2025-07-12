module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] count;

always @ (posedge clk) begin
    if (reset) begin
        count <= 0;
    end else if (count == 9) begin
        count <= 0;
    end else begin
        count <= count + 1;
    end
end

assign q = count;

endmodule