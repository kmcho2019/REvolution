module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] current_state;
reg [255:0] next_state;

integer i, j, neighbor_count;

always @ (posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

always @ (*) begin
    for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
            neighbor_count = 0;
            for (int x = -1; x <= 1; x = x + 1) begin
                for (int y = -1; y <= 1; y = y + 1) begin
                    if ((x == 0) && (y == 0)) begin
                        continue;
                    end
                    integer row = (i + x + 16) % 16;
                    integer col = (j + y + 16) % 16;
                    integer index = row * 16 + col;
                    if (current_state[index]) begin
                        neighbor_count = neighbor_count + 1;
                    end
                end
            end
            integer index = i * 16 + j;
            if (neighbor_count <= 1 || neighbor_count >= 4) begin
                next_state[index] = 1'b0;
            end else if (neighbor_count == 3) begin
                next_state[index] = 1'b1;
            end else begin
                next_state[index] = current_state[index];
            end
        end
    end
end

assign q = current_state;

endmodule