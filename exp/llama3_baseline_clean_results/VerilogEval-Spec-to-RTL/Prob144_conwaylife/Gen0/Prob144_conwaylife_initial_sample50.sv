module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] q_reg;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        reg [255:0] next_state;
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                reg [2:0] live_neighbours;
                // Calculate the number of live neighbours
                live_neighbours = (q_reg[(i-1+16)%16*16 + (j-1+16)%16]) + 
                                 (q_reg[(i-1+16)%16*16 + j]) + 
                                 (q_reg[(i-1+16)%16*16 + (j+1)%16]) + 
                                 (q_reg[i*16 + (j-1+16)%16]) + 
                                 (q_reg[i*16 + (j+1)%16]) + 
                                 (q_reg[(i+1)%16*16 + (j-1+16)%16]) + 
                                 (q_reg[(i+1)%16*16 + j]) + 
                                 (q_reg[(i+1)%16*16 + (j+1)%16]);
                // Apply the rules of the game
                if (q_reg[i*16 + j] == 1'b1) begin
                    if (live_neighbours < 2 || live_neighbours > 3) begin
                        next_state[i*16 + j] = 1'b0;
                    end else begin
                        next_state[i*16 + j] = 1'b1;
                    end
                end else begin
                    if (live_neighbours == 3) begin
                        next_state[i*16 + j] = 1'b1;
                    end else begin
                        next_state[i*16 + j] = 1'b0;
                    end
                end
            end
        end
        q_reg <= next_state;
    end
end

assign q = q_reg;

endmodule