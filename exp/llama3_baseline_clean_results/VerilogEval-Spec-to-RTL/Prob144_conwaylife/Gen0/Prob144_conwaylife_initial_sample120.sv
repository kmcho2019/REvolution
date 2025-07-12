module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] current_state;
reg [255:0] next_state;

assign q = current_state;

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

integer i, j, x, y, neighbor_count;
always @(*) begin
    for (i = 0; i < 256; i = i + 1) begin
        next_state[i] = 1'b0;
    end
    for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
            x = i * 16 + j;
            neighbor_count = 0;
            for (y = -1; y <= 1; y = y + 1) begin
                for (i = -1; i <= 1; i = i + 1) begin
                    if ((y == 0) && (i == 0)) begin
                        continue;
                    end
                    neighbor_count = neighbor_count + current_state[((((i + j) % 16) + (y * 16) + 16) % 16) + ((y + 16) % 16) * 16];
                end
            end
            case (neighbor_count)
                0, 1: next_state[x] = 1'b0;
                2: next_state[x] = current_state[x];
                3: next_state[x] = 1'b1;
                default: next_state[x] = 1'b0;
            endcase
        end
    end
end

endmodule