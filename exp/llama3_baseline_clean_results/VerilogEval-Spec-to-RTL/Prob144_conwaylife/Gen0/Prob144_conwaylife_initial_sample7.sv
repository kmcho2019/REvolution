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
integer i, j, x, y;
reg [2:0] alive_neighbors;

for (i = 0; i < 256; i = i + 1) begin
    alive_neighbors = 3'b0;
    x = i % 16;
    y = i / 16;

    for (j = -1; j <= 1; j = j + 1) begin
        for (integer k = -1; k <= 1; k = k + 1) begin
            if ((j != 0 || k != 0) && current_state[((((y + j + 16) % 16) * 16) + (x + k + 16) % 16)] == 1'b1) begin
                alive_neighbors = alive_neighbors + 1'b1;
            end
        end
    end

    case (alive_neighbors)
        3'b000, 3'b001: next_state[i] = 1'b0;
        3'b010: next_state[i] = current_state[i];
        3'b011: next_state[i] = 1'b1;
        default: next_state[i] = 1'b0;
    endcase
end

calculate_next_state = next_state;

endfunction

endmodule