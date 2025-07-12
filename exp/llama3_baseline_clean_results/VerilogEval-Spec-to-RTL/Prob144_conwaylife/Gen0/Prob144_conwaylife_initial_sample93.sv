module TopModule(
    input clk,
    input load,
    input [:0] data,
    output [255:0] q
);

reg [255:0] current_state;
reg [255:0] next_state;

integer i, j, x, y;
integer neighbors;

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    next_state ='b0;
    for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
            neighbors = 0;
            for (x = -1; x <= 1; x = x + 1) begin
                for (y = -1; y <= 1; y = y + 1) begin
                    if ((x == 0) && (y == 0)) begin
                        // skip the cell itself
                    end else begin
                        integer row, col;
                        row = (i + x +) % 16;
                        col = (j + y + 16) % 16;
                        integer index = row * 16 + col;
                        if (current_state[index]) begin
                            neighbors = neighbors + 1;
                        end
                    end
                end
            end
            integer index = i * 16 + j;
            if (neighbors ==) begin
                next_state[index] = 1'b1;
            end else if (neighbors == 2) begin
                next_state[index] = current_state[index];
            end else begin
                next_state[index] = 1'b0;
            end
        end
    end
end

assign q = current_state;

endmodule