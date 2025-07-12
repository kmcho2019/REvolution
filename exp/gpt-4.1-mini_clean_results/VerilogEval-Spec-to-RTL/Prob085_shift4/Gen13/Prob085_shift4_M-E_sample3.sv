module TopModule (
    input        clk,
    input        areset,
    input        load,
    input        ena,
    input  [3:0] data,
    output reg [3:0] q
);

reg [3:0] q_async;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q_async <= 4'b0; // Async reset
    end else begin
        q_async <= q_async; // Hold value outside synchronous block
    end
end

always @(posedge clk) begin
    if (!areset) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= {1'b0, q[3:1]}; // shift right with zero MSB
        end else begin
            q <= q;
        end
    end else begin
        q <= 4'b0;
    end
end

endmodule