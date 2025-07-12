module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Temporary storage for next state
    reg [255:0] next_q;

    // Generate logic for each cell
    genvar row, col;
    generate
        for (row = 0; row < 16; row = row + 1) begin : row_loop
            for (col = 0; col < 16; col = col + 1) begin : col_loop
                // Calculate neighbor indices with wrap-around
                wire [3:0] n_row [7:0];
                wire [3:0] n_col [7:0];
                
                assign n_row[0] = (row == 0) ? 15 : (row - 1);
                assign n_col[0] = (col == 0) ? 15 : (col - 1);
                assign n_row[1] = (row == 0) ? 15 : (row - 1);
                assign n_col[1] = col;
                assign n_row[2] = (row == 0) ? 15 : (row - 1);
                assign n_col[2] = (col == 15) ? 0 : (col + 1);
                assign n_row[3] = row;
                assign n_col[3] = (col == 0) ? 15 : (col - 1);
                assign n_row[4] = row;
                assign n_col[4] = (col == 15) ? 0 : (col + 1);
                assign n_row[5] = (row == 15) ? 0 : (row + 1);
                assign n_col[5] = (col == 0) ? 15 : (col - 1);
                assign n_row[6] = (row == 15) ? 0 : (row + 1);
                assign n_col[6] = col;
                assign n_row[7] = (row == 15) ? 0 : (row + 1);
                assign n_col[7] = (col == 15) ? 0 : (col + 1);

                // Count live neighbors
                wire [3:0] neighbor_count;
                assign neighbor_count = 
                    q[n_row[0]*16 + n_col[0]] + q[n_row[1]*16 + n_col[1]] +
                    q[n_row[2]*16 + n_col[2]] + q[n_row[3]*16 + n_col[3]] +
                    q[n_row[4]*16 + n_col[4]] + q[n_row[5]*16 + n_col[5]] +
                    q[n_row[6]*16 + n_col[6]] + q[n_row[7]*16 + n_col[7]];

                // Determine next state based on neighbor count
                always @(*) begin
                    case (neighbor_count)
                        0, 1: next_q[row*16 + col] = 1'b0;
                        2: next_q[row*16 + col] = q[row*16 + col];
                        3: next_q[row*16 + col] = 1'b1;
                        default: next_q[row*16 + col] = 1'b0;
                    endcase
                end
            end
        end
    endgenerate

    // Synchronous update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule