module TopModule(
    input clk,
    input load,
    input [255:0] data,
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

integer i, j;
integer neighbors;

for (i = 0; i < 16; i++) begin
    for (j = 0; j < 16; j++) begin
        neighbors = 0;

        // Count neighbors in all 8 directions
        for (integer x = -1; x <= 1; x++) begin
            for (integer y = -1; y <= 1; y++) begin
                if ((x == 0) && (y == 0)) begin
                    continue;
                end

                integer row = (i + x + 16) % 16;
                integer col = (j + y + 16) % 16;

                if (current_state[row * 16 + col]) begin
                    neighbors++;
                end
            end
        end

        // Apply the game rules
        if (neighbors < 2 || neighbors > 3) begin
            next_state[i * 16 + j] = 0;
        end else if (neighbors == 2) begin
            next_state[i * 16 + j] = current_state[i * 16 + j];
        end else begin
            next_state[i * 16 + j] = 1;
        end
    end
end

calculate_next_state = next_state;
endfunction

assign q = q_reg;

endmodule