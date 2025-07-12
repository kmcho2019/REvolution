module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        q <= 3'b100;  // Load 4 when a is high
    end else begin
        // Rotate right with special case for 6->0 transition
        if (q == 3'b110) begin
            q <= 3'b000;
        end else begin
            q <= {q[0], q[2:1]};  // Right rotate
        end
    end
end

endmodule