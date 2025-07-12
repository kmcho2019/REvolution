module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

parameter WIDTH = 4;
reg [WIDTH-1:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= {WIDTH{1'b0}};
    end
    else begin
        count <= count + 1'b1;  // Simple increment for better PPA
    end
end

assign q = count;

endmodule