module right_shifter(
    input clk,
    input d,
    output reg [7:0] q = 8'b0
);

    reg [7:0] q_next;

    always @(posedge clk) begin
        q_next = {d, q[7:1]};
        q <= q_next;
    end

endmodule