module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // A padded register with 0 at boundaries, length 514
    reg [513:0] padded_q;

    // Compute next state combinationally from padded_q
    wire [511:0] next_state;
    genvar i;

    generate
        for (i = 0; i < 512; i = i + 1) begin : rule110_loop
            wire left = padded_q[i + 2];
            wire center = padded_q[i + 1];
            wire right = padded_q[i];
            // Rule 110 logic
            assign next_state[i] = (~left & center) | (center ^ right);
        end
    endgenerate

    always @(posedge clk) begin
        if (load) begin
            q <= data;
            // Initialize padded_q with zeros at boundaries and data in the middle
            padded_q <= {1'b0, data, 1'b0};
        end else begin
            q <= next_state;
            // Update padded_q by shifting in the new left and right boundary zeros,
            // and updating the middle 512 bits with the next_state
            padded_q <= {1'b0, next_state, 1'b0};
        end
    end

endmodule