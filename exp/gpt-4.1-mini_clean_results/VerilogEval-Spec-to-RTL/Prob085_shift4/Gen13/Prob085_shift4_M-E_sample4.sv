module TopModule (
    input        clk,
    input        areset,
    input        load,
    input        ena,
    input  [3:0] data,
    output reg [3:0] q
);

// Asynchronous reset, synchronous load/shift logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        q[0] <= 1'b0;
        q[1] <= 1'b0;
        q[2] <= 1'b0;
        q[3] <= 1'b0;
    end else begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            // Shift right with zero fill at MSB
            q[0] <= q[1];
            q[1] <= q[2];
            q[2] <= q[3];
            q[3] <= 1'b0;
        end
        // else hold q (no change)
    end
end

endmodule