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
    for (i = 0; i < 256; i = i + 1) begin
        reg [3:0] neighbours;
        neighbours = 0;
        
        // Calculate the number of neighbours
        for (j = -1; j <= 1; j = j + 1) begin
            for (integer k = -1; k <= 1; k = k + 1) begin
                if (j == 0 && k == 0) begin
                    continue;
                end
                integer x, y;
                x = (i % 16) + j;
                y = (i / 16) + k;
                
                // Handle toroidal boundary
                if (x < 0) begin
                    x = 15;
                end else if (x >= 16) begin
                    x = 0;
                end
                if (y < 0) begin
                    y = 15;
                end else if (y >= 16) begin
                    y = 0;
                end
                
                integer neighbour_index;
                neighbour_index = y * 16 + x;
                if (current_state[neighbour_index]) begin
                    neighbours = neighbours + 1;
                end
            end
        end
        
        // Apply the rules of the game
        case (neighbours)
            0, 1: next_state[i] = 1'b0;
            2: next_state[i] = current_state[i];
            3: next_state[i] = 1'b1;
            default: next_state[i] = 1'b0;
        endcase
    end
    q = current_state;
end

endmodule