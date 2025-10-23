module TopModule(
    input        clk,
    input        reset,
    output reg [4:0] q
);

    wire feedback = q[0];

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001;
        end else begin
            q[0] <= q[1];
            q[1] <= q[2];
            q[2] <= q[3] ^ feedback; // tap at bit 3
            q[3] <= q[4];
            q[4] <= feedback;        // tap at bit 5
        end
    end

endmodule