module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Function to count live neighbors for a given cell
    function [3:0] count_neighbors;
        input [3:0] row, col;
        input [255:0] state;
        reg [3:0] row_prev, row_next, col_prev, col_next;
        begin
            row_prev = (row - 1) & 15;
            row_next = (row + 1) & 15;
            col_prev = (col - 1) & 15;
            col_next = (col + 1) & 15;
            
            count_neighbors = 
                state[row_prev*16 + col_prev] + 
                state[row_prev*16 + col] + 
                state[row_prev*16 + col_next] +
                state[row*16 + col_prev] + 
                state[row*16 + col_next] +
                state[row_next*16 + col_prev] + 
                state[row_next*16 + col] + 
                state[row_next*16 + col_next];
        end
    endfunction

    // Compute next state for all cells
    wire [255:0] next_state;
    integer i, j;
    always @(*) begin
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                reg [3:0] neighbors;
                neighbors = count_neighbors(i[3:0], j[3:0], q);
                
                case (neighbors)
                    2: next_state[i*16+j] = q[i*16+j];  // Stay same
                    3: next_state[i*16+j] = 1'b1;       // Birth
                    default: next_state[i*16+j] = 1'b0;  // Die
                endcase
            end
        end
    end

    // Sequential update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_state;
        end
    end

endmodule