module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

// Internal signals to store the next state
reg [255:0] next_q;

// Combinational logic block to calculate the next state
always @(*) begin
    next_q = q;
    for (int i = 0; i < 16; i++) begin
        for (int j = 0; j < 16; j++) begin
            // Calculate the index of the current cell
            int idx = i * 16 + j;
            
            // Calculate the number of neighbors
            int neighbors = 0;
            for (int x = -1; x <= 1; x++) begin
                for (int y = -1; y <= 1; y++) begin
                    if (x == 0 && y == 0) continue;
                    
                    // Calculate the index of the neighboring cell
                    int ni = (i + x + 16) % 16;
                    int nj = (j + y + 16) % 16;
                    int nidx = ni * 16 + nj;
                    
                    // Check if the neighboring cell is alive
                    if (q[nidx]) neighbors++;
                end
            end
            
            // Determine the next state of the current cell
            case (neighbors)
                0, 1: next_q[idx] = 1'b0;
                2: next_q[idx] = q[idx];
                3: next_q[idx] = 1'b1;
                default: next_q[idx] = 1'b0;
            endcase
        end
    end
end

// Clocked always block to update the current state
always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= next_q;
    end
end

endmodule