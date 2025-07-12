module TopModule (
    input          clk,
    input          reset,
    output reg [4:0] q
);

    reg feedback;
    reg [4:0] next_q;

    always @(*) begin
        feedback = q[0];
        next_q[4] = q[4] ^ feedback; // tap bit 5
        next_q[3] = q[4];
        next_q[2] = q[2] ^ feedback; // tap bit 3
        next_q[1] = q[2];
        next_q[0] = q[1];
    end

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001;
        end else begin
            q <= next_q;
        end
    end

endmodule