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

assign q = q_reg;

function [255:0] calculate_next_state;
input [255:0] current_state;
reg [255:0] next_state;
reg [3:0] alive_neighbors;
integer i, j;

begin
    for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
            alive_neighbors = 0;
            
            // count alive neighbors
            for (integer x = -1; x <= 1; x = x + 1) begin
                for (integer y = -1; y <= 1; y = y + 1) begin
                    if ((x == 0) && (y == 0)) begin
                        continue;
                    end
                    integer row = (i + x + 16) % 16;
                    integer col = (j + y + 16) % 16;
                    integer index = row * 16 + col;
                    if (current_state[index]) begin
                        alive_neighbors = alive_neighbors + 1;
                    end
                end
            end
            
            // apply game rules
            integer index = i * 16 + j;
            if ((alive_neighbors == 0) || (alive_neighbors == 1) || (alive_neighbors >= 4)) begin
                next_state[index] = 0;
            end else if (alive_neighbors == 2) begin
                next_state[index] = current_state[index];
            end else if (alive_neighbors == 3) begin
                next_state[index] = 1;
            end
        end
    end
    calculate_next_state = next_state;
end
endfunction

endmodule