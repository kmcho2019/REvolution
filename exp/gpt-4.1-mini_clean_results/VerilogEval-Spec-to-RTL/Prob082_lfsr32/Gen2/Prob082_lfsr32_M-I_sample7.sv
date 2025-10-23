module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);
    // Tap positions in 0-based indexing
    // taps at bits 31, 21, 1, 0 (corresponding to bits 32, 22, 2, 1 1-based)
    localparam TAP_31 = 1'b1;
    localparam TAP_21 = 1'b1;
    localparam TAP_1  = 1'b1;
    localparam TAP_0  = 1'b1;

    wire fb = q[0];

    integer i;
    reg [31:0] next_q;

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Compute next state using loop for clarity and correctness
            // bit 0 is special case
            next_q[0] = q[1];

            for (i = 1; i < 32; i = i + 1) begin
                // Check if bit i is a tap
                case (i)
                    31: next_q[i] = q[i-1] ^ fb; // tap at bit 31
                    21: next_q[i] = q[i-1] ^ fb; // tap at bit 21
                    1:  next_q[i] = q[i-1] ^ fb; // tap at bit 1
                    0:  next_q[i] = q[i-1];      // bit 0 handled separately above, but keep here for completeness
                    default: next_q[i] = q[i-1];
                endcase
            end

            q <= next_q;
        end
    end
endmodule