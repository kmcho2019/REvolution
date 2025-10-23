module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] next_q;

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= next_q;
    end
end

always @(*) begin
    next_q = q;
    for (int i = 0; i < 16; i++) begin
        for (int j = 0; j < 16; j++) begin
            reg [2:0] neighbors;
            neighbors = calculate_neighbors(q, i, j);
            case (neighbors)
                3'd0, 3'd1: next_q[(i * 16) + j] = 1'b0;
                3'd2: next_q[(i * 16) + j] = q[(i * 16) + j];
                3'd3: next_q[(i * 16) + j] = 1'b1;
                default: next_q[(i * 16) + j] = 1'b0;
            endcase
        end
    end
end

function reg [2:0] calculate_neighbors;
    input [255:0] state;
    input [3:0] i;
    input [3:0] j;
    reg [2:0] neighbors;

    neighbors = 3'd0;
    for (int x = -1; x <= 1; x++) begin
        for (int y = -1; y <= 1; y++) begin
            if ((x == 0) && (y == 0)) begin
                continue;
            end
            reg [3:0] new_i, new_j;
            new_i = (i + x + 16) % 16;
            new_j = (j + y + 16) % 16;
            if (state[(new_i * 16) + new_j] == 1'b1) begin
                neighbors = neighbors + 1;
            end
        end
    end
    calculate_neighbors = neighbors;
endfunction

endmodule