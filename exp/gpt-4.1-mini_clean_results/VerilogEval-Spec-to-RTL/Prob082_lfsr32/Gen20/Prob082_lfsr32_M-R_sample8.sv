module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Tap mask for bits 32,22,2,1 (1-based indexing)
    localparam [31:0] TAP_MASK = 32'h80200003;

    reg [31:0] next_q;

    always @(*) begin
        // Compute next LFSR state combinationally
        next_q = (q >> 1) ^ ({32{q[0]}} & TAP_MASK);
    end

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            q <= next_q;
        end
    end

endmodule