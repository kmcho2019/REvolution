module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Grid size parameters
    localparam SIZE = 16;
    localparam MASK = 4'hF; // for modulo 16 wrap-around

    // Internal wires for next state
    reg [255:0] next_q;

    integer i, ni, nj, idx_n;

    reg [3:0] r, c;         // row and column of cell i
    reg [3:0] nr, nc;       // neighbor row and column
    reg [3:0] neighbor_count;
    reg current_cell_state;

    always @* begin
        // Compute next state combinationally
        for (i = 0; i < 256; i = i + 1) begin
            r = i[7:4];  // upper 4 bits: row
            c = i[3:0];  // lower 4 bits: column

            neighbor_count = 0;
            current_cell_state = q[i];

            // Iterate over 8 neighbors
            for (ni = -1; ni <= 1; ni = ni + 1) begin
                for (nj = -1; nj <= 1; nj = nj + 1) begin
                    if (!(ni == 0 && nj == 0)) begin
                        // Compute wrapped neighbor coords using modulo 16 by masking lower 4 bits
                        nr = (r + ni) & MASK;
                        nc = (c + nj) & MASK;

                        // Compute 1D index of neighbor
                        idx_n = {nr, nc};

                        // Sum neighbor cell state
                        neighbor_count = neighbor_count + q[idx_n];
                    end
                end
            end

            // Apply rules:
            // 0-1 neighbors -> 0
            // 2 neighbors   -> cell state unchanged
            // 3 neighbors   -> 1
            // 4+ neighbors  -> 0
            case (neighbor_count)
                4'd2: next_q[i] = current_cell_state;
                4'd3: next_q[i] = 1'b1;
                default: next_q[i] = 1'b0;
            endcase
        end
    end

    // Sequential update with synchronous load
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule