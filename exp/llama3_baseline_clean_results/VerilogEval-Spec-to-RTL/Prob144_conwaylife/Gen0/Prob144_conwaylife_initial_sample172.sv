module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] state;

integer i, j;
integer neighbors;

always @(posedge clk) begin
    if (load) begin
        state <= data;
    end else begin
        reg [255:0] next_state;
        next_state <= state;
        for (i = 0; i < 16; i++) begin
            for (j = 0; j < 16; j++) begin
                neighbors = 0;
                for (integer k = -1; k <= 1; k++) begin
                    for (integer l = -1; l <= 1; l++) begin
                        if ((k == 0) && (l == 0)) begin
                            // Don't count the cell itself
                            continue;
                        end
                        integer row = (i + k + 16) % 16;
                        integer col = (j + l + 16) % 16;
                        integer index = row * 16 + col;
                        if (state[index]) begin
                            neighbors <= neighbors + 1;
                        end
                    end
                end
                integer index = i * 16 + j;
                if ((neighbors == 0) || (neighbors == 1) || (neighbors >= 4)) begin
                    next_state[index] <= 0;
                end else if (neighbors == 3) begin
                    next_state[index] <= 1;
                end
            end
        end
        state <= next_state;
    end
end

assign q = state;

endmodule