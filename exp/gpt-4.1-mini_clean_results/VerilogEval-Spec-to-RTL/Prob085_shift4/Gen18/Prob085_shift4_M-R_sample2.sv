module TopModule (
    input        clk,
    input        areset,
    input        load,
    input        ena,
    input  [3:0] data,
    output reg [3:0] q
);

wire reset_async = areset;

always @(posedge clk) begin
    if (reset_async)
        q <= 4'b0;
    else if (load)
        q <= data;
    else if (ena)
        q <= {1'b0, q[3:1]};
end

endmodule