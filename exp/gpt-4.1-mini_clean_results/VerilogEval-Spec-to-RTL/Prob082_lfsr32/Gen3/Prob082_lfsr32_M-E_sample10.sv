module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Tap positions: 32,22,2,1 correspond to indices 31,21,1,0 (0-based)
    // Create a tap mask for convenience
    localparam [31:0] TAP_MASK = (1 << 31) | (1 << 21) | (1 << 1) | (1 << 0);

    // Combinational next state wire
    wire [31:0] next_q;

    genvar i;
    generate
        for (i = 31; i >= 0; i = i - 1) begin : lfsr_bits
            if (i == 0) begin
                // LSB of next state = feedback bit (q[0])
                assign next_q[i] = q[0];
            end else begin
                // For tapped bits, next_q[i] = q[i-1] ^ q[0]
                // For non-tapped bits, next_q[i] = q[i-1]
                assign next_q[i] = q[i-1] ^ (TAP_MASK[i] ? q[0] : 1'b0);
            end
        end
    endgenerate

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            q <= next_q;
        end
    end

endmodule