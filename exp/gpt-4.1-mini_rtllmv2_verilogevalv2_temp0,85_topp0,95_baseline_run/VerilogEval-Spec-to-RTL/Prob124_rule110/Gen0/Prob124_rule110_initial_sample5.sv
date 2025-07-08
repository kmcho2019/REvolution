module TopModule (
    input        clk,
    input        load,
    input  [511:0] data,
    output reg [511:0] q
);

    integer i;
    reg [511:0] next_state;

    always @(*) begin
        // Compute next state for each cell according to Rule 110
        for (i = 0; i < 512; i = i + 1) begin
            // Define neighbors with boundary zeros
            // left = q[i+1] if i < 511 else 0
            // center = q[i]
            // right = q[i-1] if i > 0 else 0
            wire left  = (i < 511) ? q[i+1] : 1'b0;
            wire center= q[i];
            wire right = (i > 0)   ? q[i-1] : 1'b0;

            // Combine into a 3-bit pattern
            // pattern = {left, center, right}
            // Use a case statement or direct logic to assign next_state[i]

            case ({left, center, right})
                3'b111: next_state[i] = 1'b0;
                3'b110: next_state[i] = 1'b1;
                3'b101: next_state[i] = 1'b1;
                3'b100: next_state[i] = 1'b0;
                3'b011: next_state[i] = 1'b1;
                3'b010: next_state[i] = 1'b1;
                3'b001: next_state[i] = 1'b1;
                3'b000: next_state[i] = 1'b0;
                default: next_state[i] = 1'b0; // Should never happen
            endcase
        end
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule