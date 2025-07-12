module TopModule(
    input               clk,
    input               load,
    input      [1:0]    ena,
    input      [99:0]   data,
    output reg [99:0]   q
);

reg [99:0] q_next;

always @(*) begin
    case (ena)
        2'b01: begin
            // Rotate right by one bit
            q_next = {q[0], q[99:1]};
        end
        2'b10: begin
            // Rotate left by one bit
            q_next = {q[98:0], q[99]};
        end
        default: begin
            // Do not rotate
            q_next = q;
        end
    endcase
end

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= q_next;
    end
end

endmodule