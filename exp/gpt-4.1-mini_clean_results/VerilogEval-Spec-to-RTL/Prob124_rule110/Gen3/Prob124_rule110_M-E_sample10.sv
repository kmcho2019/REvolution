module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Next state logic: pad q with zero on both sides: padded_q[513:0]
    // padded_q[513] = 0 (left boundary)
    // padded_q[512:1] = q[511:0]
    // padded_q[0] = 0 (right boundary)
    wire [513:0] padded_q = {1'b0, q, 1'b0};

    // For each cell i, next state depends on bits padded_q[i+2], padded_q[i+1], padded_q[i]
    // Extract 3-bit neighborhood: {left, center, right} = padded_q[i+2 : i]
    // Compute next state bit using Rule 110 logic:
    // next = (~left & center) | (center ^ right)

    wire [511:0] next_state;
    genvar i;
    generate
        for (i=0; i<512; i=i+1) begin : compute_next
            wire left = padded_q[i+2];
            wire center = padded_q[i+1];
            wire right = padded_q[i];
            assign next_state[i] = (~left & center) | (center ^ right);
        end
    endgenerate

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule