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

// Calculate next state
always @(*) begin
    next_state = 256'b0;
    for (int i = 0; i < 16; i = i + 1) begin
        for (int j = 0; j < 16; j = j + 1) begin
            reg [2:0] alive_neighbors = 3'b0;
            for (int x = -1; x <= 1; x = x + 1) begin
                for (int y = -1; y <= 1; y = y + 1) begin
                    if (x != 0 || y != 0) begin
                        int row = (i + x + 16) % 16;
                        int col = (j + y + 16) % 16;
                        if (current_state[row * 16 + col]) begin
                            alive_neighbors = alive_neighbors + 1;
                        end
                    end
                end
            end
            if ((alive_neighbors == 3) || (alive_neighbors == 2 && current_state[i * 16 + j])) begin
                next_state[i * 16 + j] = 1'b1;
            end
        end
    end
end

assign q = current_state;

endmodule