module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    reg [255:0] q_ff;
    wire [255:0] next_q;
    reg [255:0] stable_count; // Counts consecutive stable states

    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : cell_logic
            // Calculate row and column indices with wrap-around using modulo
            wire [3:0] row = i[7:4];
            wire [3:0] col = i[3:0];
            wire [3:0] row_prev = (row == 0) ? 15 : (row - 1);
            wire [3:0] row_next = (row == 15) ? 0 : (row + 1);
            wire [3:0] col_prev = (col == 0) ? 15 : (col - 1);
            wire [3:0] col_next = (col == 15) ? 0 : (col + 1);

            // Get neighbor values with shared calculations
            wire n_top_left = q_ff[{row_prev,col_prev}];
            wire n_top = q_ff[{row_prev,col}];
            wire n_top_right = q_ff[{row_prev,col_next}];
            wire n_left = q_ff[{row,col_prev}];
            wire n_right = q_ff[{row,col_next}];
            wire n_bottom_left = q_ff[{row_next,col_prev}];
            wire n_bottom = q_ff[{row_next,col}];
            wire n_bottom_right = q_ff[{row_next,col_next}];

            // Optimized 2-level neighbor counting
            wire [1:0] sum_top = n_top_left + n_top + n_top_right;
            wire [1:0] sum_bottom = n_bottom_left + n_bottom + n_bottom_right;
            wire [1:0] sum_sides = n_left + n_right;
            wire [2:0] neighbor_count = sum_top + sum_bottom + sum_sides;

            // Next state calculation with stability detection
            wire next_state = (neighbor_count == 3) ? 1'b1 :
                            (neighbor_count == 2) ? q_ff[i] :
                            1'b0;

            // Clock gating for stable cells
            wire cell_active = (stable_count[i] < 2) || (next_state != q_ff[i]);
            assign next_q[i] = cell_active ? next_state : q_ff[i];
        end
    endgenerate

    always @(posedge clk) begin
        if (load) begin
            q_ff <= data;
            stable_count <= 256'b0;
        end else begin
            // Update all cells with clock gating optimization
            q_ff <= next_q;
            
            // Update stability counters
            for (integer i = 0; i < 256; i = i + 1) begin
                stable_count[i] <= (next_q[i] == q_ff[i]) ? 
                                  (stable_count[i] + 1) : 
                                  4'b0;
            end
        end
        q <= q_ff;
    end

endmodule