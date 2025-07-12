module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] current_state;

always_ff @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= calculate_next_state(current_state);
    end
end

function [255:0] calculate_next_state;
input [255:0] current_state;
reg [255:0] next_state;
integer i, j;

for (i = 0; i < 16; i++) begin
    for (j = 0; j < 16; j++) begin
        reg [2:0] alive_neighbors;
        alive_neighbors = 0;
        
        // count alive neighbors
        for (integer x = -1; x <= 1; x++) begin
            for (integer y = -1; y <= 1; y++) begin
                if ((x != 0) || (y != 0)) begin
                    reg [7:0] x_coord, y_coord;
                    x_coord = (i + x) % 16;
                    y_coord = (j + y) % 16;
                    if (current_state[x_coord * 16 + y_coord]) begin
                        alive_neighbors = alive_neighbors + 1;
                    end
                end
            end
        end
        
        // apply game rules
        case (alive_neighbors)
            3'd0, 3'd1: next_state[i * 16 + j] = 1'd0;
            3'd2: next_state[i * 16 + j] = current_state[i * 16 + j];
            3'd3: next_state[i * 16 + j] = 1'd1;
            default: next_state[i * 16 + j] = 1'd0;
        endcase
    end
end

calculate_next_state = next_state;

endfunction

assign q = current_state;

endmodule