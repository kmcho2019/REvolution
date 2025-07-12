module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] current_state;
reg [255:0] next_state;

integer i, j, k, neighbor_count;

// Function to count neighbors for a given cell
function integer count_neighbors;
    input [7:0] x, y;
    integer neighbor_count = 0;
    for (i = -1; i <= 1; i = i + 1) begin
        for (j = -1; j <= 1; j = j + 1) begin
            if ((i == 0) && (j == 0))
                continue;
            neighbor_count = neighbor_count + current_state[((((x + i + 16) % 16) * 16) + ((y + j + 16) % 16))];
        end
    end
    count_neighbors = neighbor_count;
endfunction

// Main logic
always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        for (k = 0; k < 256; k = k + 1) begin
            i = k / 16;
            j = k % 16;
            neighbor_count = count_neighbors(i, j);
            if (neighbor_count <= 1 || neighbor_count >= 4) begin
                next_state[k] <= 1'b0;
            end else if (neighbor_count == 2) begin
                next_state[k] <= current_state[k];
            end else if (neighbor_count == 3) begin
                next_state[k] <= 1'b1;
            end
        end
        current_state <= next_state;
    end
end

assign q = current_state;

endmodule