module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q
);

always @(posedge areset) begin
    if (areset) q <= 4'b0;
end

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end
    else if (ena) begin
        q <= {1'b0, q[3:1]};  // Explicit right shift with zero fill
    end
end

endmodule