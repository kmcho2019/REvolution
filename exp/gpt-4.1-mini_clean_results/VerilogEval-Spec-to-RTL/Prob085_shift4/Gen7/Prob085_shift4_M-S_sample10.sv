module TopModule (
    input        clk,
    input        areset,
    input        load,
    input        ena,
    input  [3:0] data,
    output reg [3:0] q
);

always @(posedge clk or posedge areset) begin
    if (areset)
        q <= 0;
    else if (load)
        q <= data;
    else if (ena)
        q <= q[3:1] << 0; // shift right by 1 with zero-fill at MSB
end

endmodule