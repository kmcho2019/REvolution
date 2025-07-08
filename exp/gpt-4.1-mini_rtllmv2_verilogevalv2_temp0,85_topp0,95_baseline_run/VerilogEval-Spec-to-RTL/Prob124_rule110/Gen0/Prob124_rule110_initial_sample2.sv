module TopModule (
    input        clk,
    input        load,
    input  [511:0] data,
    output reg [511:0] q
);

    // Next state calculation wire
    reg [511:0] next_q;

    integer i;

    always @(*) begin
        for (i = 0; i < 512; i = i + 1) begin
            // Neighbors with zero padding outside boundaries
            // Left[i+1]
            wire left = (i == 511) ? 1'b0 : q[i+1];
            // Center[i]
            wire center = q[i];
            // Right[i-1]
            wire right = (i == 0) ? 1'b0 : q[i-1];

            // Apply Rule 110 logic:
            // Using the truth table from the prompt, we map the triplet (left, center, right) to next state.
            // Rule 110 binary representation: 01101110 (from 7 to 0)
            // The pattern bits correspond to (left center right) as a 3-bit number:
            // triplet: l c r -> next state bit
            // 111 (7) -> 0
            // 110 (6) -> 1
            // 101 (5) -> 1
            // 100 (4) -> 0
            // 011 (3) -> 1
            // 010 (2) -> 1
            // 001 (1) -> 1
            // 000 (0) -> 0
            case ({left, center, right})
                3'b111: next_q[i] = 1'b0;
                3'b110: next_q[i] = 1'b1;
                3'b101: next_q[i] = 1'b1;
                3'b100: next_q[i] = 1'b0;
                3'b011: next_q[i] = 1'b1;
                3'b010: next_q[i] = 1'b1;
                3'b001: next_q[i] = 1'b1;
                3'b000: next_q[i] = 1'b0;
                default: next_q[i] = 1'b0; // Should never occur
            endcase
        end
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule