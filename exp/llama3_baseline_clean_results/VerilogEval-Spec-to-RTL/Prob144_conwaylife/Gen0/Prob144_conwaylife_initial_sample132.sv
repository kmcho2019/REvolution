module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] state;
reg [255:0] nextState;

integer i, j;

always @(posedge clk) begin
    if (load) begin
        state <= data;
    end else begin
        state <= nextState;
    end
end

always @(*) begin
    for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
            reg [2:0] aliveNeighbours;
            aliveNeighbours = 0;

            // Count alive neighbours
            for (integer x = -1; x <= 1; x = x + 1) begin
                for (integer y = -1; y <= 1; y = y + 1) begin
                    if ((x != 0 || y != 0) && state[((((i + x) % 16) * 16) + ((j + y) % 16))]) begin
                        aliveNeighbours = aliveNeighbours + 1;
                    end
                end
            end

            // Update cell state
            if (aliveNeighbours < 2 || aliveNeighbours > 3) begin
                nextState[(((i * 16) + j))] = 0;
            end else if (aliveNeighbours == 3) begin
                nextState[(((i * 16) + j))] = 1;
            end else begin
                nextState[(((i * 16) + j))] = state[(((i * 16) + j))];
            end
        end
    end
end

assign q = state;

endmodule