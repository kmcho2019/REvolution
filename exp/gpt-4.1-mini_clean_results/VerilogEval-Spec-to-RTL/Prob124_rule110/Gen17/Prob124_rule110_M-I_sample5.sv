module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    // Pipeline registers
    reg [511:0] stage1_q;      // Holds current state q at stage 1
    reg [513:0] ext_q;         // Extended vector with zero padding at stage 2 input

    wire [511:0] next_q;

    // Rule 110 function: next state = (~left & center) | (center ^ right)
    function automatic bit rule110_cell(input bit left, input bit center, input bit right);
        rule110_cell = (~left & center) | (center ^ right);
    endfunction

    // Generate next state combinational logic from ext_q
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : compute_next_state
            wire left   = ext_q[i+2];   // left neighbor (i+1)
            wire center = ext_q[i+1];   // current cell i
            wire right  = ext_q[i];     // right neighbor (i-1)
            assign next_q[i] = rule110_cell(left, center, right);
        end
    endgenerate

    always @(posedge clk) begin
        if (load) begin
            // On load, directly load input data into output and pipeline registers
            q        <= data;
            stage1_q <= data;
            ext_q    <= {1'b0, data, 1'b0};
        end else begin
            // Stage 1: latch current state q to stage1_q
            stage1_q <= q;
            // Stage 2 input: create extended vector with zero padding
            ext_q <= {1'b0, stage1_q, 1'b0};
            // Update output q with next state from previous ext_q
            // Note: next_q is combinational function of ext_q, so it reflects ext_q from this cycle
            q <= next_q;
        end
    end

endmodule