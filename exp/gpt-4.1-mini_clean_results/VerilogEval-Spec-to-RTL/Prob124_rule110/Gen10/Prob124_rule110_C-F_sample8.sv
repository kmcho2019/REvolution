module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    // Pad q with zeros on both sides to simplify neighbor access
    wire [513:0] padded_q = {1'b0, q, 1'b0};

    wire [511:0] next_q;

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : next_state_gen
            wire left   = padded_q[i + 2];
            wire center = padded_q[i + 1];
            wire right  = padded_q[i];
            // Rule 110 next state logic:
            // next = (~left & center) | (center ^ right)
            assign next_q[i] = (~left & center) | (center ^ right);
        end
    endgenerate

    // Sequential logic: update q on posedge clk; load from data if load is high
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule