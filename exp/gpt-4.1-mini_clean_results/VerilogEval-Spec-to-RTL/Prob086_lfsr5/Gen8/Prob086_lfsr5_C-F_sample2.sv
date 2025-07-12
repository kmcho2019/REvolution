module TopModule (
    input        clk,
    input        reset,
    output reg [4:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001; // synchronous reset to 1
        end else begin
            wire feedback = q[0];
            q <= {feedback,
                  q[4],
                  q[3] ^ feedback,
                  q[2],
                  q[1]};
        end
    end

endmodule