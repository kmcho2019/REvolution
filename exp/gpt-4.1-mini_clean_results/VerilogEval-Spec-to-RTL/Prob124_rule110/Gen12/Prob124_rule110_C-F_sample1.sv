module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    // Extend q with zero padding on both ends for boundary conditions
    wire [513:0] ext_q = {1'b0, q, 1'b0};

    // Next state computation for each of the 512 cells
    wire [511:0] next_state;

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule110_logic
            wire left   = ext_q[i+2];
            wire center = ext_q[i+1];
            wire right  = ext_q[i];
            // Rule 110 next state formula:
            // next = (~left & center) | (center ^ right)
            assign next_state[i] = (~left & center) | (center ^ right);
        end
    endgenerate

    // Synchronous update of q: load input data or advance to next state
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule