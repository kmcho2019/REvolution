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
                reg [2:0] neighbours;
                reg [15:0] row_offset;
                row_offset = i * 16;
                neighbours = 0;
                
                // Calculate neighbours
                for (int x = -1; x <= 1; x++) begin
                    for (int y = -1; y <= 1; y++) begin
                        if ((x == 0) && (y == 0)) begin
                            continue;
                        end else begin
                            reg [3:0] x_index, y_index;
                            x_index = (j + x + 16) % 16;
                            y_index = (i + y + 16) % 16;
                            neighbours = neighbours + q_reg[y_index * 16 + x_index];
                        end
                    end
                end
                
                // Calculate next state
                if ((neighbours == 2) && q_reg[row_offset + j]) begin
                    next_state[row_offset + j] = 1;
                end else if ((neighbours == 3) || ((neighbours == 2) &&!q_reg[row_offset + j])) begin
                    next_state[row_offset + j] = 1;
                end else begin
                    next_state[row_offset + j] = 0;
                end
            end
        end
        q_reg <= next_state;
    end
end

assign q = q_reg;

endmodule