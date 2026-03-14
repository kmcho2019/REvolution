module TopModule (
    input  wire        clk,
    input  wire        load,
    input  wire [255:0] data,
    output reg  [255:0] q
);
    // combinational next‑state vector
    logic [255:0] next_state;
    // loop indices and temporary variables
    integer r, c, dr, dc;
    integer idx, nidx;
    integer rr, cc;
    integer cnt;

    // ------------------------------------------------------------
    //  Combinational neighbour counting and rule evaluation
    // ------------------------------------------------------------
    always_comb begin
        // evaluate each cell of the 16x16 toroidal grid
        for (r = 0; r < 16; r = r + 1) begin
            for (c = 0; c < 16; c = c + 1) begin
                cnt = 0;
                // examine the eight neighbours with wrap‑around
                for (dr = -1; dr <= 1; dr = dr + 1) begin
                    for (dc = -1; dc <= 1; dc = dc + 1) begin
                        if (dr != 0 || dc != 0) begin
                            rr = (r + dr) & 4'hF; // modulo 16 (row)
                            cc = (c + dc) & 4'hF; // modulo 16 (col)
                            nidx = rr * 16 + cc;   // linear index of neighbour
                            cnt = cnt + q[nidx];   // accumulate live neighbours
                        end
                    end
                end
                idx = r * 16 + c; // linear index of current cell
                // apply the rule set
                if (cnt == 2) begin
                    next_state[idx] = q[idx];   // unchanged
                end else if (cnt == 3) begin
                    next_state[idx] = 1'b1;     // become alive
                end else begin
                    next_state[idx] = 1'b0;     // die / stay dead
                end
            end
        end
    end

    // ------------------------------------------------------------
    //  Sequential state register with synchronous load
    // ------------------------------------------------------------
    always_ff @(posedge clk) begin
        if (load)
            q <= data;          // load initial pattern
        else
            q <= next_state;    // advance one timestep
    end
endmodule