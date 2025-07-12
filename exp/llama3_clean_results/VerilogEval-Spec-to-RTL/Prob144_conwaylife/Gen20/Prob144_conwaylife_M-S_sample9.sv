module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] current_state;

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        for (int i = 0; i < 256; i = i + 1) begin
            int row = i / 16;
            int col = i % 16;
            reg [3:0] count = 0;
            for (int x = -1; x <= 1; x = x + 1) begin
                for (int y = -1; y <= 1; y = y + 1) begin
                    if (x != 0 || y != 0) begin
                        int neighbor_row = (row + x + 16) % 16;
                        int neighbor_col = (col + y + 16) % 16;
                        int neighbor_index = (neighbor_row * 16) + neighbor_col;
                        if (current_state[neighbor_index]) begin
                            count = count + 1;
                        end
                    end
                end
            end
            reg next_state;
            if (count == 3 || (count == 2 && current_state[i])) begin
                next_state = 1'b1;
            end else begin
                next_state = 1'b0;
            end
            current_state[i] <= next_state;
        end
    end
end

always @(*) begin
    q = current_state;
end

endmodule