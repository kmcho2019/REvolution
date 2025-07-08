module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);
    // Function to compute next state of one cell given left, center, right bits
    function logic next_state;
        input logic left, center, right;
        begin
            // Rule 110 logic from truth table:
            // Mapping neighborhood (left, center, right) to next state:
            // 111 -> 0
            // 110 -> 1
            // 101 -> 1
            // 100 -> 0
            // 011 -> 1
            // 010 -> 1
            // 001 -> 1
            // 000 -> 0
            // We can implement as:
            next_state = (left & center & right) ? 1'b0 :
                         (left & center & ~right) ? 1'b1 :
                         (left & ~center & right) ? 1'b1 :
                         (left & ~center & ~right) ? 1'b0 :
                         (~left & center & right) ? 1'b1 :
                         (~left & center & ~right) ? 1'b1 :
                         (~left & ~center & right) ? 1'b1 :
                         1'b0; // (~left & ~center & ~right)
        end
    endfunction

    integer i;
    reg [511:0] next_q;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Compute next state for each cell
            // Boundaries have neighbors 0
            for (i = 0; i < 512; i = i + 1) begin
                logic left, center, right;
                left = (i == 511) ? 1'b0 : q[i+1];
                center = q[i];
                right = (i == 0) ? 1'b0 : q[i-1];
                next_q[i] = next_state(left, center, right);
            end
            q <= next_q;
        end
    end

endmodule