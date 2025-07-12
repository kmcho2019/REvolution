module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Tap mask for bits 31, 21, 1, 0 (0-based indexing)
    localparam [31:0] TAP_MASK = (1 << 31) | (1 << 21) | (1 << 1) | 1;

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            reg feedback;
            reg [31:0] next_q;
            integer i;

            feedback = q[0];
            next_q = q >> 1;

            if (feedback) begin
                // XOR feedback only into tapped bits using the mask
                // This applies XOR feedback bitwise on tapped bits
                next_q = next_q ^ TAP_MASK;
            end

            q <= next_q;
        end
    end

endmodule