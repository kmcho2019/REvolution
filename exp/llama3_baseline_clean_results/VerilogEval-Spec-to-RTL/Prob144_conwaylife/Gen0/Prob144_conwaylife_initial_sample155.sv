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
integer i, j;

begin
    for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
            reg [7:0] neighbors;
            integer x, y;

            neighbors = 8'b0;
            for (x = -1; x <= 1; x = x + 1) begin
                for (y = -1; y <= 1; y = y + 1) begin
                    if ((x == 0) && (y == 0)) begin
                        // skip current cell
                    end else begin
                        integer idx, neighbor_idx;
                        idx = (i * 16) + j;
                        neighbor_idx = (((((i + x) % 16) * 16) + ((j + y) % 16)) % 256);
                        if (current_state[neighbor_idx]) begin
                            neighbors = neighbors + 1'b1;
                        end
                    end
                end
            end

            integer idx;
            idx = (i * 16) + j;
            if ((neighbors <= 1) || (neighbors >= 4)) begin
                next_state[idx] = 1'b0;
            end else if (neighbors == 2) begin
                next_state[idx] = current_state[idx];
            end else if (neighbors == 3) begin
                next_state[idx] = 1'b1;
            end
        end
    end
    calculate_next_state = next_state;
end
endfunction

endmodule