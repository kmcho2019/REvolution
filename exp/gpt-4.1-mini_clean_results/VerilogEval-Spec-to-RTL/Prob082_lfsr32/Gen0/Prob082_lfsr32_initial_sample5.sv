module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Tap positions: 32, 22, 2, 1 (1-based)
    // 0-based indices: 31, 21, 1, 0

    wire feedback;
    assign feedback = q[0];

    integer i;

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Shift right by one, with XOR at tapped positions
            // q[31] = q[30] ^ feedback if tapped
            // We build the next q value bit by bit

            // Temporary variable for next state
            reg [31:0] next_q;

            // Calculate next_q bits
            next_q[31] = q[30] ^ feedback; // tap at bit 32 (index 31)
            next_q[21] = q[22] ^ feedback; // tap at bit 22 (index 21)
            next_q[1]  = q[2]  ^ feedback; // tap at bit 2  (index 1)
            next_q[0]  = q[0];             // bit 1 tap handled differently as q[0] is used as feedback bit

            // For bits that are not taps and not MSB or LSB
            for (i = 30; i >= 0; i = i -1) begin
                if (i != 21 && i != 1 && i != 0)
                    next_q[i] = q[i+1];
            end

            q <= next_q;
        end
    end

endmodule