module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] q_next;

// Calculate the number of alive neighbors for a cell
function [2:0] count_neighbors;
input [15:0] x;
input [15:0] y;
reg [2:0] count_neighbors;
reg [255:0] temp_q;
begin
    count_neighbors = 0;
    for (int i = -1; i <= 1; i++) begin
        for (int j = -1; j <= 1; j++) begin
            if ((i == 0) && (j == 0)) begin
                continue;
            end
            temp_q = q;
            count_neighbors = count_neighbors + temp_q[((((x + i) % 16) * 16) + ((y + j) % 16))];
        end
    end
end
endfunction

// Update the state of a cell based on the number of alive neighbors
function [0:0] update_cell;
input [2:0] neighbors;
input [0:0] current_state;
begin
    case (neighbors)
        0, 1: update_cell = 0;
        2: update_cell = current_state;
        3: update_cell = 1;
        default: update_cell = 0;
    endcase
end
endfunction

always @(*) begin
    if (load) begin
        q_next = data;
    end else begin
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                reg [2:0] neighbors;
                reg [0:0] current_state;
                neighbors = count_neighbors(i, j);
                current_state = q[((i * 16) + j)];
                q_next[((i * 16) + j)] = update_cell(neighbors, current_state);
            end
        end
    end
end

always @(posedge clk) begin
    q <= q_next;
end

endmodule