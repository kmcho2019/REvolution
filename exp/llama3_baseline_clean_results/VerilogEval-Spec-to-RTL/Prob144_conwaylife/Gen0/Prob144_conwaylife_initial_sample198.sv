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

for (i = 0; i < 16; i = i + 1) begin
    for (j = 0; j < 16; j = j + 1) begin
        reg [7:0] neighbors;
        integer x, y;

        neighbors = 8'd0;
        for (x = -1; x <= 1; x = x + 1) begin
            for (y = -1; y <= 1; y = y + 1) begin
                if (x == 0 && y == 0) begin
                    continue;
                end
                integer nx, ny;
                nx = (i + x + 16) % 16;
                ny = (j + y + 16) % 16;
                if (current_state[nx * 16 + ny]) begin
                    neighbors = neighbors + 1;
                end
            end
        end

        case (neighbors)
            0, 1: next_state[i * 16 + j] = 1'd0;
            2: next_state[i * 16 + j] = current_state[i * 16 + j];
            3: next_state[i * 16 + j] = 1'd1;
            default: next_state[i * 16 + j] = 1'd0;
        endcase
    end
end

calculate_next_state = next_state;
endfunction

endmodule