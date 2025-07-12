module TopModule (
    input         clk,
    input         load,
    input  [255:0] data,
    output [255:0] q
);

reg [255:0] current_state;

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        reg [255:0] next_state;
        integer i;
        for (i = 0; i < 256; i++) begin
            reg [2:0] neighbors;
            integer x, y;
            x = i % 16;
            y = i / 16;
            neighbors = 0;
            // calculate neighbors for each cell in the toroid
            for (integer dx = -1; dx <= 1; dx++) begin
                for (integer dy = -1; dy <= 1; dy++) begin
                    integer nx, ny;
                    nx = (x + dx + 16) % 16;
                    ny = (y + dy + 16) % 16;
                    if ((dx != 0 || dy != 0) && current_state[ny * 16 + nx]) begin
                        neighbors <= neighbors + 1;
                    end
                end
            end
            // update cell state based on the number of neighbors
            if (neighbors < 2 || neighbors > 3) begin
                next_state[i] <= 0;
            end else if (neighbors == 2) begin
                next_state[i] <= current_state[i];
            end else if (neighbors == 3) begin
                next_state[i] <= 1;
            end
        end
        current_state <= next_state;
    end
end

assign q = current_state;

endmodule