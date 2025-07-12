module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

// Function to get wrapped row index
function [3:0] wrap_row;
    input [3:0] row;
    input signed [4:0] offset;
    begin
        wrap_row = (row + offset + 16) % 16;
    end
endfunction

// Function to get wrapped column index
function [3:0] wrap_col;
    input [3:0] col;
    input signed [4:0] offset;
    begin
        wrap_col = (col + offset + 16) % 16;
    end
endfunction

// Function to count live neighbors for a cell
function [3:0] count_neighbors;
    input [3:0] row;
    input [3:0] col;
    reg [3:0] n_row, n_col;
    integer i, j;
    begin
        count_neighbors = 0;
        for (i = -1; i <= 1; i = i + 1) begin
            for (j = -1; j <= 1; j = j + 1) begin
                if (i == 0 && j == 0) continue; // skip self
                n_row = wrap_row(row, i);
                n_col = wrap_col(col, j);
                if (q[n_row * 16 + n_col]) begin
                    count_neighbors = count_neighbors + 1;
                end
            end
        end
    end
endfunction

// Next state logic
wire [255:0] next_q;
genvar r, c;
generate
    for (r = 0; r < 16; r = r + 1) begin : row_gen
        for (c = 0; c < 16; c = c + 1) begin : col_gen
            wire [3:0] neighbors = count_neighbors(r[3:0], c[3:0]);
            wire current = q[r * 16 + c];
            reg next;
            
            always @(*) begin
                case (neighbors)
                    0, 1: next = 0;
                    2: next = current;
                    3: next = 1;
                    default: next = 0; // 4+
                endcase
            end
            
            assign next_q[r * 16 + c] = next;
        end
    end
endgenerate

// State register
always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= next_q;
    end
end

endmodule