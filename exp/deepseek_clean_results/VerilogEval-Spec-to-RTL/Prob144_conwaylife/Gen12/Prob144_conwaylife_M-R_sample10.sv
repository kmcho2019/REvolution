module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    function [3:0] count_neighbors;
        input [3:0] row, col;
        input [255:0] state;
        reg [3:0] row_prev, row_next, col_prev, col_next;
        reg [7:0] n0, n1, n2, n3, n4, n5, n6, n7;
        begin
            // Toroidal wrapping with bitwise masking
            row_prev = (row - 1) & 15;
            row_next = (row + 1) & 15;
            col_prev = (col - 1) & 15;
            col_next = (col + 1) & 15;
            
            // Neighbor indices using shift instead of multiply
            n0 = {row_prev, col_prev};
            n1 = {row_prev, col};
            n2 = {row_prev, col_next};
            n3 = {row, col_prev};
            n4 = {row, col_next};
            n5 = {row_next, col_prev};
            n6 = {row_next, col};
            n7 = {row_next, col_next};
            
            // Count neighbors
            count_neighbors = state[n0] + state[n1] + state[n2] + 
                             state[n3] + state[n4] + 
                             state[n5] + state[n6] + state[n7];
        end
    endfunction

    wire [255:0] next_q;
    integer i, j;
    always @(*) begin
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                automatic [3:0] cnt = count_neighbors(i[3:0], j[3:0], q);
                next_q[(i<<4)+j] = (cnt == 3) ? 1'b1 : 
                                  (cnt == 2) ? q[(i<<4)+j] : 
                                  1'b0;
            end
        end
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule