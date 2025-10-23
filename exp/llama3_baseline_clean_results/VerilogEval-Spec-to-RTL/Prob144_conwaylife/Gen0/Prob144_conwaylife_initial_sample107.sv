module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] q;

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        reg [255:0] next_state;
        next_state = q;
        
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                reg [7:0] neighbors;
                neighbors = 0;
                
                for (int x = -1; x <= 1; x++) begin
                    for (int y = -1; y <= 1; y++) begin
                        if ((x == 0) && (y == 0)) begin
                            continue;
                        end
                        reg [7:0] idx_x;
                        reg [7:0] idx_y;
                        idx_x = (i + x + 16) % 16;
                        idx_y = (j + y + 16) % 16;
                        reg [7:0] idx;
                        idx = (idx_x * 16) + idx_y;
                        if (q[idx]) begin
                            neighbors = neighbors + 1;
                        end
                    end
                end
                
                reg [7:0] cell_idx;
                cell_idx = (i * 16) + j;
                
                if ((neighbors < 2) || (neighbors > 3)) begin
                    next_state[cell_idx] = 0;
                end else if (neighbors == 3) begin
                    next_state[cell_idx] = 1;
                end
            end
        end
        
        q <= next_state;
    end
end

endmodule