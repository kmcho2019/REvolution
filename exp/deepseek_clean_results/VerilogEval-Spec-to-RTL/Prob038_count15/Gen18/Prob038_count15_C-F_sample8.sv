module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'b0000;
    end
    else begin
        // Efficient parallel bitwise toggling with clear conditions
        count[0] <= ~count[0];
        count[1] <= (count[0]) ? ~count[1] : count[1];
        count[2] <= (&count[1:0]) ? ~count[2] : count[2];
        count[3] <= (&count[2:0]) ? ~count[3] : count[3];
    end
end

assign q = count;

endmodule