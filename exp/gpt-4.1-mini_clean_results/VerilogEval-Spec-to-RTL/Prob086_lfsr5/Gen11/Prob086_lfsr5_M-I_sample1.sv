module TopModule (
    input        clk,
    input        reset,
    output reg [4:0] q
);

    reg feedback;

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001;  // synchronous reset to 1
        end else begin
            feedback = q[0];
            q[4] <= feedback ^ q[4];  // tap at bit 5 (q[4])
            q[3] <= q[4];
            q[2] <= feedback ^ q[2];  // tap at bit 3 (q[2])
            q[1] <= q[2];
            q[0] <= q[1];
        end
    end

endmodule