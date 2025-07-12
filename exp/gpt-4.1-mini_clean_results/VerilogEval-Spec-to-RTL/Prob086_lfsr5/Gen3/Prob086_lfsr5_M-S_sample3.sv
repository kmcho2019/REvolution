module TopModule (
    input        clk,
    input        reset,
    output reg [4:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001;
        end else begin
            wire fb = q[0];
            q <= { q[4] ^ fb, q[4], q[2] ^ fb, q[2], q[1] };
        end
    end

endmodule