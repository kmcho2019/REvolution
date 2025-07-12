module TopModule(
    input  clk,
    input  load,
    input  [255:0] data,
    output [255:0] q
);

reg [255:0] q_reg;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        q_reg <= compute_next_state(q_reg);
    end
end

assign q = q_reg;

function [255:0] compute_next_state;
input [255:0] q_in;
reg [255:0] q_out;
integer i, j;
begin
    for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
            reg [2:0] neighbours;
            neighbours = count_neighbours(q_in, i, j);
            case (neighbours)
                0, 1: q_out[(i * 16) + j] = 1'b0;
                2: q_out[(i * 16) + j] = q_in[(i * 16) + j];
                3: q_out[(i * 16) + j] = 1'b1;
                default: q_out[(i * 16) + j] = 1'b0;
            endcase
        end
    end
    compute_next_state = q_out;
end
endfunction

function [2:0] count_neighbours;
input [255:0] q_in;
input [3:0] i;
input [3:0] j;
reg [2:0] count;
begin
    count = 3'b0;
    for (integer x = -1; x <= 1; x = x + 1) begin
        for (integer y = -1; y <= 1; y = y + 1) begin
            if ((x != 0) || (y != 0)) begin
                integer ii, jj;
                ii = (i + x + 16) % 16;
                jj = (j + y + 16) % 16;
                if (q_in[(ii * 16) + jj] == 1'b1) begin
                    count = count + 1'b1;
                end
            end
        end
    end
    count_neighbours = count;
end
endfunction

endmodule