module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Pad current state with zeros on both ends to handle boundaries
    wire [513:0] padded_q = {1'b0, q, 1'b0};

    // Compute next state combinationally for each cell
    wire [511:0] next_state;
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule110_logic
            wire left = padded_q[i + 2];
            wire center = padded_q[i + 1];
            wire right = padded_q[i];
            // Rule 110 next state formula
            assign next_state[i] = (~left & center) | (center ^ right);
        end
    endgenerate

    // Synchronous update or load on clock edge
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule