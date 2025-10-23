module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output reg [7:0] q
);

// Configuration constant - could be made a parameter for more flexibility
localparam SHIFT_MODE = 1'b0;  // 0 = parallel load, 1 = shift mode

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 8'b0;
    end
    else begin
        if (SHIFT_MODE) begin
            // Circular shift right operation (unused in current mode)
            q <= {q[0], q[7:1]};
        end
        else begin
            // Parallel load operation
            q <= d;
        end
    end
end

endmodule