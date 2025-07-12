module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);
    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001;
        end else begin
            // feedback bit is the output bit q[0]
            wire feedback = q[0];
            // next state of q:
            // q[0] <= q[1];
            // q[1] <= q[2];
            // q[2] <= q[3] ^ feedback; // tapped
            // q[3] <= q[4];
            // q[4] <= q[4] ^ feedback; // tapped
            q <= {q[4] ^ feedback, q[4], q[3] ^ feedback, q[2], q[1]};
        end
    end
endmodule