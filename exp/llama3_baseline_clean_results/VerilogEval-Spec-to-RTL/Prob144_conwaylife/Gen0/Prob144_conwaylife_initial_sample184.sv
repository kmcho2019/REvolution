module TopModule (
    input  clk,
    input  load,
    input  [255:0] data,
    output [255:0] q
);

reg [255:0] q_reg;

integer i, j;
reg [255:0] next_q;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        q_reg <= next_q;
    end
end

always @(*) begin
    next_q = 256'b0;
    for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
            reg [2:0] neighbours;
            neighbours = get_neighbours(q_reg, i, j);
            if (q_reg[i*16 + j] == 1'b1) begin
                if ((neighbours == 3'b010) || (neighbours == 3'b011)) begin
                    next_q[i*16 + j] = 1'b1;
                end else begin
                    next_q[i*16 + j] = 1'b0;
                end
            end else begin
                if (neighbours == 3'b011) begin
                    next_q[i*16 + j] = 1'b1;
                end
            end
        end
    end
end

function [2:0] get_neighbours;
input [255:0] q;
input [3:0] i;
input [3:0] j;
integer x, y;
reg [2:0] neighbours;

begin
    neighbours = 3'b000;
    for (x = -1; x <= 1; x = x + 1) begin
        for (y = -1; y <= 1; y = y + 1) begin
            if ((x != 0) || (y != 0)) begin
                if (q[((i + x + 16) % 16)*16 + ((j + y + 16) % 16)] == 1'b1) begin
                    neighbours = neighbours + 1'b1;
                end
            end
        end
    end
    get_neighbours = neighbours;
end
endfunction

assign q = q_reg;

endmodule