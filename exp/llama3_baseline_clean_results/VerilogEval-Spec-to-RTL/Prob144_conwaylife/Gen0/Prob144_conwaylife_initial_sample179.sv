module TopModule(
    input clk,
    input load,
    input [255:0] data,
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
    for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
            integer neighbor_count = 0;
            integer x, y;
            for (x = -1; x <= 1; x = x + 1) begin
                for (y = -1; y <= 1; y = y + 1) begin
                    if (x == 0 && y == 0) begin
                        // Do not count the cell itself as a neighbor
                    end else begin
                        integer idx = ((i + x) % 16) * 16 + (j + y) % 16;
                        if (current_state[idx]) begin
                            neighbor_count = neighbor_count + 1;
                        end
                    end
                end
            end

            integer idx = i * 16 + j;
            if (neighbor_count <= 1 || neighbor_count >= 4) begin
                next_state[idx] = 1'b0;
            end else if (neighbor_count == 2) begin
                next_state[idx] = current_state[idx];
            end else if (neighbor_count == 3) begin
                next_state[idx] = 1'b1;
            end
        end
    end
end

assign q = current_state;

endmodule