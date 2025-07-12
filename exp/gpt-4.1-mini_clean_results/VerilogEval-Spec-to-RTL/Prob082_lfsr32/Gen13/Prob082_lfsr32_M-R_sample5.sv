module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    localparam [31:0] TAP_MASK = 32'h80200003; // Taps at bits 31,21,1,0 (zero-indexed)

    wire [31:0] next_state;

    assign next_state = (q >> 1) ^ (q[0] ? TAP_MASK : 32'b0);

    always @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else
            q <= next_state;
    end

endmodule