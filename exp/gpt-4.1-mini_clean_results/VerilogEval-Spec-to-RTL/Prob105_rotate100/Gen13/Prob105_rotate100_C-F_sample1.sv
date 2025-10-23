module TopModule (
    input             clk,
    input             load,
    input      [1:0]  ena,
    input      [99:0] data,
    output reg [99:0] q
);

    reg [99:0] next_q;

    always @* begin
        if (load) begin
            next_q = data;
        end else if (ena == 2'b10) begin
            // rotate left by 1
            next_q = {q[98:0], q[99]};
        end else if (ena == 2'b01) begin
            // rotate right by 1
            next_q = {q[0], q[99:1]};
        end else begin
            // no rotation
            next_q = q;
        end
    end

    always @(posedge clk) begin
        q <= next_q;
    end

endmodule