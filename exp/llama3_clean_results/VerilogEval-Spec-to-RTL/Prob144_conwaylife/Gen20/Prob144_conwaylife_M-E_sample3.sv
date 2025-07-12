module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] current_state;
reg [255:0] next_state;

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

integer i, j;
always @(*) begin
    next_state = 256'b0;
    for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
            reg [7:0] neighbor_count;
            neighbor_count = 8'b0;
            // Calculate neighbors using modular arithmetic
            for (integer x = -1; x <= 1; x = x + 1) begin
                for (integer y = -1; y <= 1; y = y + 1) begin
                    if (x == 0 && y == 0) begin
                        // Skip self
                        continue;
                    end
                    integer ni, nj;
                    ni = (i + x + 16) % 16;
                    nj = (j + y + 16) % 16;
                    if (current_state[ni*16 + nj]) begin
                        neighbor_count = neighbor_count + 1;
                    end
                end
            end
            // Compute next state using bitwise operations
            if ((neighbor_count == 3) || (neighbor_count == 2 && current_state[i*16 + j])) begin
                next_state[i*16 + j] = 1'b1;
            end
        end
    end
end

assign q = current_state;

endmodule