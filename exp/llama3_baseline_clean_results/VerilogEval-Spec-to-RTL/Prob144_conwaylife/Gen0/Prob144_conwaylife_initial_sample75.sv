module TopModule (
    input  clk,
    input  load,
    input  [255:0] data,
    output [255:0] q
);

reg [255:0] current_state;
reg [255:0] next_state;

integer i, j, x, y;

always @ (posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

always @ (*) begin
    for (i = 0; i < 256; i++) begin
        next_state[i] = 1'b0;
    end

    for (i = 0; i < 16; i++) begin
        for (j = 0; j < 16; j++) begin
            integer neighbors = 0;
            for (x = -1; x <= 1; x++) begin
                for (y = -1; y <= 1; y++) begin
                    if (x == 0 && y == 0) begin
                        continue;
                    end

                    integer col = (j + y + 16) % 16;
                    integer row = (i + x + 16) % 16;
                    integer index = row * 16 + col;

                    if (current_state[index]) begin
                        neighbors++;
                    end
                end
            end

            integer index = i * 16 + j;
            if (neighbors == 2) begin
                next_state[index] = current_state[index];
            end else if (neighbors == 3) begin
                next_state[index] = 1'b1;
            end
        end
    end
end

assign q = current_state;

endmodule