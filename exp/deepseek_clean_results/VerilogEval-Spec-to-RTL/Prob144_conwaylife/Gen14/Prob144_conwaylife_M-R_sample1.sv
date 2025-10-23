module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Function to calculate wrapped neighbor position
    function [3:0] wrap;
        input [3:0] pos;
        begin
            wrap = (pos == 4'd15) ? 4'd0 : 
                   (pos == 4'd0) ? 4'd15 : 
                   pos;
        end
    endfunction

    // Function to count live neighbors for a given cell
    function [3:0] count_neighbors;
        input [7:0] row;
        input [7:0] col;
        reg [3:0] row_p, row_n, col_p, col_n;
        begin
            row_p = wrap(row - 1);
            row_n = wrap(row + 1);
            col_p = wrap(col - 1);
            col_n = wrap(col + 1);
            
            count_neighbors = 
                q[row_p*16 + col_p] + q[row_p*16 + col] + q[row_p*16 + col_n] +
                q[row*16 + col_p] + q[row*16 + col_n] +
                q[row_n*16 + col_p] + q[row_n*16 + col] + q[row_n*16 + col_n];
        end
    endfunction

    // Combinational next state logic
    wire [255:0] next_q;
    generate
        genvar i;
        for (i = 0; i < 256; i = i + 1) begin : next_state
            wire [3:0] row = i / 16;
            wire [3:0] col = i % 16;
            wire [3:0] neighbors = count_neighbors(row, col);
            
            assign next_q[i] = (neighbors == 3) ? 1'b1 :
                              (neighbors == 2) ? q[i] :
                              1'b0;
        end
    endgenerate

    // Sequential update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule