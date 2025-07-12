module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    // Pipeline register to hold next state computation before committing to q
    reg [511:0] next_q_stage;

    // Zero-pad q to simplify boundary neighbor extraction
    wire [513:0] ext_q = {1'b0, q, 1'b0};

    wire [511:0] next_q_comb;

    // Rule 110 function: next state = (~left & center) | (center ^ right)
    function automatic bit rule110_cell(input bit left, input bit center, input bit right);
        rule110_cell = (~left & center) | (center ^ right);
    endfunction

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : next_state_gen
            wire left   = ext_q[i + 2];
            wire center = ext_q[i + 1];
            wire right  = ext_q[i];
            assign next_q_comb[i] = rule110_cell(left, center, right);
        end
    endgenerate

    always @(posedge clk) begin
        if (load) begin
            q <= data;
            next_q_stage <= 512'b0; // Clear pipeline stage on load
        end else begin
            next_q_stage <= next_q_comb; // Stage 1: compute next state
            q <= next_q_stage;            // Stage 2: update q from pipeline
        end
    end

endmodule