//===================================================================
// TopModule – 16×16 Toroidal Cellular Automaton (Conway‑Life variant)
//===================================================================
// Interface (exact as required)
//   input  logic        clk   – rising‑edge clock
//   input  logic        load  – synchronous active‑high load enable
//   input  logic [255:0] data – pattern loaded when load=1
//   output logic [255:0] q     – current grid state
//===================================================================
module TopModule (
    input  logic        clk,
    input  logic        load,
    input  logic [255:0] data,
    output logic [255:0] q
);

    // ----------------------------------------------------------------
    // Internal state register (registered grid) and combinational next state
    // ----------------------------------------------------------------
    logic [255:0] cur_state;   // present generation
    logic [255:0] next_state;  // combinational next generation

    // ----------------------------------------------------------------
    // Combinational neighbour counting and rule evaluation
    // ----------------------------------------------------------------
    // Grid indexing: idx = row*16 + col   (row, col in 0..15)
    // Toroidal wrap‑around is performed with a 4‑bit mask ("& 4'hF").
    always_comb begin : compute_next
        int   r, c, dr, dc;          // loop indices (compile‑time constants)
        logic [3:0] cnt;             // neighbour count fits 0‑8
        int   rr, cc, idx;
        // Evaluate every cell – each cell is assigned exactly once
        for (r = 0; r < 16; r = r + 1) begin
            for (c = 0; c < 16; c = c + 1) begin
                cnt = 4'd0;
                // Count the eight neighbours
                for (dr = -1; dr <= 1; dr = dr + 1) begin
                    for (dc = -1; dc <= 1; dc = dc + 1) begin
                        if (dr != 0 || dc != 0) begin
                            rr  = (r + dr) & 4'hF;          // wrap row
                            cc  = (c + dc) & 4'hF;          // wrap col
                            idx = rr * 16 + cc;             // neighbour linear index
                            cnt = cnt + cur_state[idx];
                        end
                    end
                end
                idx = r * 16 + c; // current cell index
                // Apply the rule set
                if (cnt == 4'd2)
                    next_state[idx] = cur_state[idx]; // unchanged
                else if (cnt == 4'd3)
                    next_state[idx] = 1'b1;           // birth
                else
                    next_state[idx] = 1'b0;           // death / under‑/over‑population
            end
        end
    end

    // ----------------------------------------------------------------
    // Sequential state register with synchronous load
    // ----------------------------------------------------------------
    always_ff @(posedge clk) begin
        if (load)
            cur_state <= data;      // load initial pattern
        else
            cur_state <= next_state; // advance one generation
    end

    // ----------------------------------------------------------------
    // Output driver – single continuous assignment to satisfy single‑driver rule
    // ----------------------------------------------------------------
    assign q = cur_state;

endmodule