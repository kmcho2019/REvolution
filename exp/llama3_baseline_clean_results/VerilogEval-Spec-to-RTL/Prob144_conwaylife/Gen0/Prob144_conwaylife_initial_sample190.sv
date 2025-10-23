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

    for (i = 0; i < 16; i++) begin
        for (j = 0; j < 16; j++) begin
            neighbors = 0;
            for (integer x = -1; x <= 1; x++) begin
                for (integer y = -1; y <= 1; y++) begin
                    if (x == 0 && y == 0) begin
                        continue;
                    end
                    neighbors += current_state[((((i + x) % 16) * 16) + ((j + y) % 16))];
                end
            end
            if (neighbors <= 1 || neighbors >= 4) begin
                next_state[((i * 16) + j)] = 0;
            end else if (neighbors == 3) begin
                next_state[((i * 16) + j)] = 1;
            end else begin
                next_state[((i * 16) + j)] = current_state[((i * 16) + j)];
            end
        end
    end
    update_state = next_state;
endfunction

endmodule