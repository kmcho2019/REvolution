module TopModule (
    input         clk,
    input         areset,
    input         load,
    input         ena,
    input  [3:0]  data,
    output reg [3:0] q
);

// Asynchronous reset block: resets q immediately on positive edge of areset
always @(posedge areset) begin
    q <= 4'b0;
end

// Synchronous logic block: load and shift operations happen on posedge clk when not in reset
always @(posedge clk) begin
    if (!areset) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= {1'b0, q[3:1]};
        end
        // else retain q
    end
    // If areset asserted, q is already reset asynchronously
end

endmodule