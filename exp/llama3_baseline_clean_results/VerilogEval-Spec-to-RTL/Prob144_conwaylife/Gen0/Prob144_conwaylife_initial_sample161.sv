module TopModule(
    input  clk,
    input  load,
    input  [255:0] data,
    output [255:0] q
);

reg [255:0] current_state;
reg [255:0] next_state;

integer i, j;

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    next_state = 256'b0;
    for (i = 0; i < 16; i++) begin
        for (j = 0; j < 16; j++) begin
            reg [2:0] alive_neighbors;
            alive_neighbors = count_alive_neighbors(current_state, i, j);
            if (current_state[i*16 + j]) begin
                case (alive_neighbors)
                    3'b000, 3'b001: next_state[i*16 + j] = 1'b0;
                    3'b010: next_state[i*16 + j] = current_state[i*16 + j];
                    3'b011: next_state[i*16 + j] = 1'b1;
                    default: next_state[i*16 + j] = 1'b0;
                endcase
            end else begin
                case (alive_neighbors)
                    3'b011: next_state[i*16 + j] = 1'b1;
                    default: next_state[i*16 + j] = 1'b0;
                endcase
            end
        end
    end
end

function [2:0] count_alive_neighbors;
    input [255:0] state;
    input [3:0] i;
    input [3:0] j;
    reg [2:0] count;
    integer x, y;
    count = 3'b000;
    for (x = -1; x <= 1; x++) begin
        for (y = -1; y <= 1; y++) begin
            if ((x != 0 || y != 0) && state[((((i + x) % 16) * 16) + ((j + y) % 16))]) begin
                count = count + 1;
            end
        end
    end
    count_alive_neighbors = count;
endfunction

assign q = current_state;

endmodule