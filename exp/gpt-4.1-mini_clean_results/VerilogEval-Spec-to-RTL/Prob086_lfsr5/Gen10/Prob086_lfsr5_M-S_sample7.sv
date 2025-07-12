module TopModule(
    input        clk,
    input        reset,
    output reg [4:0] q
);

    always @(posedge clk) begin
        if (reset)
            q <= 5'b00001;
        else begin
            wire feedback = q[0];
            q <= {q[4] ^ feedback, q[3], q[2] ^ feedback, q[1], q[0]};
        end
    end

endmodule