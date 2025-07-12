module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    integer i;
    reg [513:0] ext_q;  // zero-padded state for boundary conditions
    reg [511:0] next_state;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Pad q with zeros at both ends
            ext_q = {1'b0, q, 1'b0};

            // Compute next state using Rule 110 logic
            for (i = 0; i < 512; i = i + 1) begin
                // Extract neighbors
                // left = ext_q[i+2], center = ext_q[i+1], right = ext_q[i]
                next_state[i] = (~ext_q[i+2] & ext_q[i+1]) | (ext_q[i+1] ^ ext_q[i]);
            end
            q <= next_state;
        end
    end

endmodule