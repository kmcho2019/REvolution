module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    // Pipeline stage registers
    reg [513:0] ext_q_reg;      // Registered extended vector with zero padding
    reg [511:0] next_q_reg;     // Registered next state from stage 2

    // Stage 1: Prepare extended vector with zero padding
    // Load priority: if load asserted, load data padded; else use current q padded
    always @(posedge clk) begin
        if (load) begin
            ext_q_reg <= {1'b0, data, 1'b0};
        end else begin
            ext_q_reg <= {1'b0, q, 1'b0};
        end
    end

    // Rule 110 combinational function
    function automatic bit rule110_cell(input bit left, input bit center, input bit right);
        rule110_cell = (~left & center) | (center ^ right);
    endfunction

    // Stage 2: Compute next state cells from ext_q_reg
    // Use a generate block with local wires to minimize glitches and fanout
    wire [511:0] next_q_comb;
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : next_state_compute
            wire left   = ext_q_reg[i+2];   // left neighbor
            wire center = ext_q_reg[i+1];   // current cell
            wire right  = ext_q_reg[i];     // right neighbor
            assign next_q_comb[i] = rule110_cell(left, center, right);
        end
    endgenerate

    // Register the computed next state on clk
    always @(posedge clk) begin
        if (load) begin
            // When loading, directly update q with data
            q <= data;
        end else begin
            // Otherwise, update q with pipeline registered next state
            next_q_reg <= next_q_comb;
            q <= next_q_reg;
        end
    end

endmodule