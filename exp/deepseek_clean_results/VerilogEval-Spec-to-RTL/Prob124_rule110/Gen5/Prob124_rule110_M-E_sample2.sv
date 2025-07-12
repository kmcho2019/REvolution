module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Next state computation
    wire [511:0] next_state;

    // Boundary conditions (virtual cells 512 and -1 are 0)
    wire left_of_0 = 1'b0;
    wire right_of_511 = 1'b0;

    // Generate all 512 cells
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : cell
            // Neighbor selection
            wire left = (i == 0) ? left_of_0 : q[i-1];
            wire center = q[i];
            wire right = (i == 511) ? right_of_511 : q[i+1];

            // Rule 110 implementation
            // Truth table implementation using case equivalence
            assign next_state[i] = (left & center & ~right) ? 1'b1 :
                                  (left & ~center & right) ? 1'b1 :
                                  (~left & center) ? 1'b1 :
                                  (~left & ~center & right) ? 1'b1 :
                                  1'b0;
        end
    endgenerate

    // State update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_state;
        end
    end

endmodule