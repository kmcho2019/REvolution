module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] q_next;

// Function to calculate the number of neighbors for a cell
function [3:0] count_neighbors;
    input [15:0] x;
    input [15:0] y;
    reg [3:0] count_neighbors;
    count_neighbors = 0;

    // Check all 8 neighboring cells
    for (int i = -1; i <= 1; i++) begin
        for (int j = -1; j <= 1; j++) begin
            if (i == 0 && j == 0) continue; // Skip the cell itself
            // Calculate the wrapped coordinates
            reg [3:0] x_wrap = (x + i + 16) % 16;
            reg [3:0] y_wrap = (y + j + 16) % 16;
            // Check if the neighboring cell is alive
            if (q[y_wrap * 16 + x_wrap] == 1'b1) begin
                count_neighbors = count_neighbors + 1;
            end
        end
    end
endfunction

// Update q_next according to the game rules
always @(*) begin
    if (load) begin
        q_next = data;
    end else begin
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                reg [3:0] neighbors = count_neighbors(j, i);
                case (neighbors)
                    4'b0000, 4'b0001: q_next[i * 16 + j] = 1'b0;
                    4'b0010: q_next[i * 16 + j] = q[i * 16 + j];
                    4'b0011: q_next[i * 16 + j] = 1'b1;
                    default: q_next[i * 16 + j] = 1'b0;
                endcase
            end
        end
    end
end

// Update q at the positive edge of the clock
always @(posedge clk) begin
    q <= q_next;
end

endmodule