module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [513:0] padded_q;  // q padded with zeros at both ends: {0, q, 0}
    wire [511:0] next_state;

    // Pad q with zeros at boundaries to simplify neighbor indexing
    assign padded_q = {1'b0, q, 1'b0};

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule110_logic
            // Neighbors:
            // left = padded_q[i + 1]
            // center = padded_q[i + 2]
            // right = padded_q[i]
            wire left = padded_q[i + 1];
            wire center = padded_q[i + 2];
            wire right = padded_q[i];

            // Rule 110 next state boolean formula:
            // next = (~left & center) | (center ^ right);
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