module TopModule (
    input  clk,
    input  load,
    input  [255:0] data,
    output [255:0] q
);

reg [255:0] current_state;
reg [255:0] next_state;

integer i, j, k, neighbor_count;
reg [255:0] temp_state;

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    for (i = 0; i < 256; i++) begin
        next_state[i] = 0;
    end

    for (i = 0; i < 16; i++) begin
        for (j = 0; j < 16; j++) begin
            neighbor_count = 0;
            for (k = -1; k <= 1; k++) begin
                for (integer l = -1; l <= 1; l++) begin
                    if (k == 0 && l == 0) begin
                        continue;
                    end

                    integer row = (i + k + 16) % 16;
                    integer col = (j + l + 16) % 16;
                    integer index = row * 16 + col;

                    neighbor_count += current_state[index];
                end
            end

            integer index = i * 16 + j;
            if (neighbor_count == 3) begin
                next_state[index] = 1;
            end else if (neighbor_count == 2 && current_state[index] == 1) begin
                next_state[index] = 1;
            end
        end
    end
end

assign q = current_state;

endmodule