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
        q <= 4'b0;          // Asynchronous reset to zero
    else if (load)
        q <= data;          // Synchronous load with priority
    else if (ena)
        q <= {1'b0, q[3:1]}; // Synchronous right shift with zero fill
end

endmodule