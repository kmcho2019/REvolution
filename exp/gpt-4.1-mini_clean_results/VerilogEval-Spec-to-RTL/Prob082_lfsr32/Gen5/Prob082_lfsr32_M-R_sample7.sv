module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    localparam [31:0] TAP_MASK = (1 << 31) | (1 << 21) | (1 << 1) | (1 << 0);

    wire feedback = q[0];
    wire [31:0] next_state = feedback ? ((q >> 1) ^ TAP_MASK) : (q >> 1);

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            q <= next_state;
        end
    end

endmodule