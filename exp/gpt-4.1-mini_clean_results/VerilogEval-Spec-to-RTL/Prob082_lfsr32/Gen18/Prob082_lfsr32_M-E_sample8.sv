module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Define taps zero-indexed: bit 31 (pos 32), 21 (pos 22), 1 (pos 2), 0 (pos 1)
    localparam TAPS = 32'b10000000000100000000000000000011;

    integer i;
    reg feedback;

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            feedback = q[0];
            q[0] = q[1] ^ (TAPS[0] ? feedback : 1'b0);
            // shift and apply feedback at taps for bits 1 to 30
            for (i = 1; i < 31; i = i + 1) begin
                q[i] = q[i+1] ^ (TAPS[i] ? feedback : 1'b0);
            end
            q[31] = feedback; // MSB gets feedback
        end
    end

endmodule