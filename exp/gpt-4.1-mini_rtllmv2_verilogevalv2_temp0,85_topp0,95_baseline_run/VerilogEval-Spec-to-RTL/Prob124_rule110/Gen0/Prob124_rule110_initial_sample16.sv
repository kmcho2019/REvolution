module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Function to compute the next state of a single cell given left, center, right bits
    function next_state;
        input left, center, right;
        begin
            // According to Rule 110:
            // Left Center Right | Next
            // 1    1     1     -> 0
            // 1    1     0     -> 1
            // 1    0     1     -> 1
            // 1    0     0     -> 0
            // 0    1     1     -> 1
            // 0    1     0     -> 1
            // 0    0     1     -> 1
            // 0    0     0     -> 0

            // Encoding the rule as a truth table for next_state:
            // Convert triplet to 3-bit number: {left, center, right}
            // 7:111->0, 6:110->1, 5:101->1, 4:100->0, 3:011->1, 2:010->1, 1:001->1, 0:000->0

            case ({left, center, right})
                3'b111: next_state = 0;
                3'b110: next_state = 1;
                3'b101: next_state = 1;
                3'b100: next_state = 0;
                3'b011: next_state = 1;
                3'b010: next_state = 1;
                3'b001: next_state = 1;
                3'b000: next_state = 0;
                default: next_state = 0; // default safety
            endcase
        end
    endfunction

    integer i;
    reg [511:0] next_q;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Compute next state for each cell
            for (i = 0; i < 512; i = i + 1) begin
                // Determine left neighbor (i+1), center (i), right (i-1)
                // Boundary conditions: q[-1] and q[512] = 0
                // left = q[i+1] if i < 511 else 0
                // center = q[i]
                // right = q[i-1] if i > 0 else 0

                next_q[i] = next_state(
                    (i < 511) ? q[i+1] : 1'b0,
                    q[i],
                    (i > 0) ? q[i-1] : 1'b0
                );
            end
            q <= next_q;
        end
    end

endmodule