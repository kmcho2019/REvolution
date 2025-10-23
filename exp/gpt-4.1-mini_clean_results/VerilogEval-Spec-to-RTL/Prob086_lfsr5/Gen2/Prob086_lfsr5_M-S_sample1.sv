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
            q[4] <= q[4] ^ feedback;
            q[3] <= q[4];
            q[2] <= q[2] ^ feedback;
            q[1] <= q[2];
            q[0] <= q[1];
        end
    end

endmodule