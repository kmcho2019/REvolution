module TopModule (
    input  clk,
    input  load,
    input  [255:0] data,
    output [255:0] q
);

reg [255:0] q_reg;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        q_reg <= calculate_next_state(q_reg);
    end
end

function [255:0] calculate_next_state;
input [255:0] current_state;
reg [255:0] next_state;
reg [2:0] neighbors;
integer i, j;

for (i = 0; i < 16; i = i + 1) begin
    for (j = 0; j < 16; j = j + 1) begin
        neighbors = 0;
        // Calculate the indices of the neighboring cells, wrapping around the edges
        for (integer k = -1; k <= 1; k = k + 1) begin
            for (integer l = -1; l <= 1; l = l + 1) begin
                if ((k != 0) || (l != 0)) begin
                    neighbors = neighbors + current_state[(i + k + 16) % 16 * 16 + (j + l + 16) % 16];
                end
            end
        end
        // Update the next state of the current cell based on the number of its neighbors
        if (neighbors <= 1) begin
            next_state[i * 16 + j] = 0;
        end else if (neighbors == 2) begin
            next_state[i * 16 + j] = current_state[i * 16 + j];
        end else if (neighbors == 3) begin
            next_state[i * 16 + j] = 1;
        end else begin
            next_state[i * 16 + j] = 0;
        end
    end
end
calculate_next_state = next_state;
endfunction

assign q = q_reg;

endmodule