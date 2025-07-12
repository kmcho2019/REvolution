module TopModule (
    input         clk,
    input         areset,
    input         load,
    input         ena,
    input  [3:0]  data,
    output reg [3:0] q
);

reg q0, q1, q2, q3;

always @(posedge areset or posedge clk) begin
    if (areset) begin
        q0 <= 1'b0;
        q1 <= 1'b0;
        q2 <= 1'b0;
        q3 <= 1'b0;
    end else begin
        if (load) begin
            q0 <= data[0];
            q1 <= data[1];
            q2 <= data[2];
            q3 <= data[3];
        end else if (ena) begin
            q0 <= q1;
            q1 <= q2;
            q2 <= q3;
            q3 <= 1'b0;
        end
    end
end

always @(*) begin
    q = {q3, q2, q1, q0};
end

endmodule