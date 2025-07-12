module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [513:0] padded_q; // zero padded boundaries
    assign padded_q = {1'b0, q, 1'b0};

    reg [511:0] next_state;

    integer i;
    always @* begin
        for (i = 0; i < 512; i = i + 1) begin
            wire left = padded_q[i + 2];
            wire center = padded_q[i + 1];
            wire right = padded_q[i];
            // next = (center & ~left) | (center & ~right) | (~center & right);
            next_state[i] = (center & ~left) | (center & ~right) | (~center & right);
        end
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule