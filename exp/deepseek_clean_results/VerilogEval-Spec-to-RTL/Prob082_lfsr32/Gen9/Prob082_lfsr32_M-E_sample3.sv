module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

wire [31:0] next_q;
genvar i;

generate
    for (i = 0; i < 32; i = i + 1) begin : lfsr_logic
        if (i == 31 || i == 21 || i == 1 || i == 0) begin
            // Tap positions (adjusted for 0-based indexing)
            assign next_q[i] = (i == 0) ? q[31] : (q[i-1] ^ q[0]);
        end else begin
            // Non-tap positions
            assign next_q[i] = (i == 0) ? q[31] : q[i-1];
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