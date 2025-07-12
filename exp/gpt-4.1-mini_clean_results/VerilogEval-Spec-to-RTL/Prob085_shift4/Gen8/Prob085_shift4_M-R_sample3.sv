module TopModule (
    input        clk,
    input        areset,
    input        load,
    input        ena,
    input  [3:0] data,
    output reg [3:0] q
);

reg [3:0] q_next;

always @(*) begin
    if (load) begin
        q_next = data;
    end else if (ena) begin
        q_next = {1'b0, q[3:1]};
    end else begin
        q_next = q;
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 4'b0;
    end else begin
        q <= q_next;
    end
end

endmodule