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
        q_reg <= update_state(q_reg);
    end
end

assign q = q_reg;

function [255:0] update_state;
input [255:0] current_state;
reg [255:0] next_state;
reg [2:0] neighbors;
integer i, j;

begin
    next_state = 256'b0;
    for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
            neighbors = count_neighbors(current_state, i, j);
            if (current_state[i*16 + j] == 1'b1) begin
                case (neighbors)
                    3'd2: next_state[i*16 + j] = 1'b1;
                    3'd3: next_state[i*16 + j] = 1'b1;
                    default: next_state[i*16 + j] = 1'b0;
                endcase
            end else begin
                case (neighbors)
                    3'd3: next_state[i*16 + j] = 1'b1;
                    default: next_state[i*16 + j] = 1'b0;
                endcase
            end
        end
    end
    update_state = next_state;
end
endfunction

function [2:0] count_neighbors;
input [255:0] current_state;
input [3:0] i, j;

reg [2:0] neighbors;

begin
    neighbors = 3'b0;
    for (integer x = -1; x <= 1; x = x + 1) begin
        for (integer y = -1; y <= 1; y = y + 1) begin
            if ((x == 0) && (y == 0)) begin
                continue;
            end
            if (current_state[((i + x + 16) % 16)*16 + ((j + y + 16) % 16)] == 1'b1) begin
                neighbors = neighbors + 3'b1;
            end
        end
    end
    count_neighbors = neighbors;
end
endfunction

endmodule