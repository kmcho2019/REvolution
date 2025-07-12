module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] current_state;
reg [255:0] next_state;

assign q = current_state;

integer i, j;

always @(*) begin
    for (i = 0; i < 16; i++) begin
        for (j = 0; j < 16; j++) begin
            integer neighbor_count = 0;
            integer cell_index = i * 16 + j;

            // count neighbors
            for (integer k = -1; k <= 1; k++) begin
                for (integer l = -1; l <= 1; l++) begin
                    if (k == 0 && l == 0) continue;
                    integer x = (i + k + 16) % 16;
                    integer y = (j + l + 16) % 16;
                    integer neighbor_index = x * 16 + y;
                    neighbor_count += current_state[neighbor_index];
                end
            end

            // calculate next state
            if (current_state[cell_index] == 1'b1) begin
                if (neighbor_count == 2) begin
                    next_state[cell_index] = 1'b1;
                end else begin
                    next_state[cell_index] = (neighbor_count == 3) ? 1'b1 : 1'b0;
                end
            end else begin
                next_state[cell_index] = (neighbor_count == 3) ? 1'b1 : 1'b0;
            end
        end
    end
end

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

endmodule