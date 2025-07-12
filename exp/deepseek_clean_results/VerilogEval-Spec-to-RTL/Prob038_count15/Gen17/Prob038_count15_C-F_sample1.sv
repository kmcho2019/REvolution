module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

parameter WIDTH = 4;
reg [WIDTH-1:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= {WIDTH{1'b0}};  // Synchronous reset to 0
    end
    else begin
        // Efficient parallel bitwise toggling:
        // Each bit toggles when all lower bits are 1
        count[0] <= ~count[0];
        count[1] <= (count[0]) ? ~count[1] : count[1];
        count[2] <= (&count[1:0]) ? ~count[2] : count[2];
        count[3] <= (&count[2:0]) ? ~count[3] : count[3];
    end
end

assign q = count;

endmodule