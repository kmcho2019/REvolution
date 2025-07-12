module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    function [0:0] get_next_state;
        input [3:0] row, col;
        input [255:0] current_q;
        reg [3:0] neighbor_count;
        reg [3:0] row_p, row_n, col_p, col_n;
        begin
            // Toroidal wrapping using bitwise masking
            row_p = (row - 1) & 15;
            row_n = (row + 1) & 15;
            col_p = (col - 1) & 15;
            col_n = (col + 1) & 15;
            
            // Count neighbors using shift for row calculation
            neighbor_count = 
                current_q[(row_p << 4) + col_p] + 
                current_q[(row_p << 4) + col]   + 
                current_q[(row_p << 4) + col_n] + 
                current_q[(row << 4) + col_p]   + 
                current_q[(row << 4) + col_n]   + 
                current_q[(row_n << 4) + col_p] + 
                current_q[(row_n << 4) + col]   + 
                current_q[(row_n << 4) + col_n];
            
            // State transition rules
            get_next_state = (neighbor_count == 3) ? 1'b1 :
                           (neighbor_count == 2) ? current_q[(row << 4) + col] :
                           1'b0;
        end
    endfunction

    // Calculate next state
    wire [255:0] next_q;
    genvar i, j;
    generate
        for (i = 0; i < 16; i = i + 1) begin : row_loop
            for (j = 0; j < 16; j = j + 1) begin : col_loop
                assign next_q[(i << 4) + j] = get_next_state(i[3:0], j[3:0], q);
            end
        end
    endgenerate

    // Clocked state update
    always @(posedge clk) begin
        q <= load ? data : next_q;
    end

endmodule