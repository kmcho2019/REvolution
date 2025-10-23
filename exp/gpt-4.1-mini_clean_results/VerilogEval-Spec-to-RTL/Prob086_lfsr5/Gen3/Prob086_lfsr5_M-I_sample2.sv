module TopModule (
    input        clk,
    input        reset,
    output reg [4:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001;
        end else begin
            wire feedback = q[0];
            reg [4:0] next_q;

            next_q[4] = q[4] ^ feedback; // tap at bit 5 (q[4])
            next_q[3] = q[4];
            next_q[2] = q[2] ^ feedback; // tap at bit 3 (q[2])
            next_q[1] = q[2];
            next_q[0] = q[1];

            q <= next_q;
        end
    end

endmodule