module TopModule (
    input        clk,
    input        areset,
    input        load,
    input        ena,
    input  [3:0] data,
    output reg [3:0] q
);

// Asynchronous reset
always @(posedge areset or posedge clk) begin
    if (areset)
        q <= 4'b0;
    else begin
        // Synchronous load and shift logic with load priority
        if (load)
            q <= data;
        else if (ena)
            q <= {1'b0, q[3:1]};
    end
end

endmodule