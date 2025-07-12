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
reg [2:0] neighbour_count;
integer i, j, x, y;
begin
    next_state = 256'd0;
    for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
            neighbour_count = 3'd0;
            for (x = -1; x <= 1; x = x + 1) begin
                for (y = -1; y <= 1; y = y + 1) begin
                    if ((x != 0 || y != 0) && current_state[((((i + x + 16) % 16) * 16) + (j + y + 16) % 16)]) begin
                        neighbour_count = neighbour_count + 1'd1;
                    end
                end
            end
            case (neighbour_count)
                3'd0, 3'd1: next_state[(i * 16) + j] = 1'd0;
                3'd2: next_state[(i * 16) + j] = current_state[(i * 16) + j];
                3'd3: next_state[(i * 16) + j] = 1'd1;
                default: next_state[(i * 16) + j] = 1'd0;
            endcase
        end
    end
    calculate_next_state = next_state;
end
endfunction

assign q = q_reg;

endmodule