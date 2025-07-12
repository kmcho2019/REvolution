module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            wire fb = q[0];
            // Shift right by 1 bit
            q <= {
                q[31] ^ fb,   // bit 31 tap
                q[30:22],
                q[21] ^ fb,   // bit 21 tap
                q[20:2],
                q[1] ^ fb,    // bit 1 tap
                q[0]
            };
        end
    end

endmodule