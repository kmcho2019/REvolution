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
        reg [255:0] next_state;
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                reg [2:0] neighbors;
                // Calculate the number of neighbors
                neighbors = calculate_neighbors(q_reg, i, j);
                // Update the state of the cell based on the number of neighbors
                next_state[(i*16)+j] <= update_cell(q_reg[(i*16)+j], neighbors);
            end
        end
        q_reg <= next_state;
    end
end

function reg [2:0] calculate_neighbors;
    input [255:0] state;
    input [3:0] i;
    input [3:0] j;
    reg [2:0] neighbors;
    reg [3:0] x, y;
    neighbors = 0;
    for (x = -1; x <= 1; x++) begin
        for (y = -1; y <= 1; y++) begin
            if ((x == 0) && (y == 0)) begin
                // Don't count the cell itself
            end else begin
                reg [3:0] xi, yi;
                xi = (i + x + 16) % 16;
                yi = (j + y + 16) % 16;
                neighbors += state[(xi*16)+yi];
            end
        end
    end
    calculate_neighbors = neighbors;
endfunction

function reg update_cell;
    input cell;
    input [2:0] neighbors;
    case (neighbors)
        3'b000, 3'b001: update_cell = 1'b0;
        3'b010: update_cell = cell;
        3'b011: update_cell = 1'b1;
        default: update_cell = 1'b0;
    endcase
endfunction

assign q = q_reg;

endmodule