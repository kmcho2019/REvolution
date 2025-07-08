module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);
    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001;
        end else begin
            // Compute feedback from q[0]
            // q[4] next = q[4] ^ q[0]
            // q[3] next = q[3] (not tapped)
            // q[2] next = q[2] ^ q[0]
            // q[1] next = q[1] (not tapped)
            // q[0] next = q[1] (shift right)

            q <= { (q[4] ^ q[0]),
                   q[3],
                   (q[2] ^ q[0]),
                   q[1],
                   q[0] };
        end
    end
endmodule