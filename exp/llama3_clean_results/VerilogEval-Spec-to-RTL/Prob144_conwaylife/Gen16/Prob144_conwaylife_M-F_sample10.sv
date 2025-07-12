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
        next_state <= current_state;
        for (int i = 0; i < 256; i++) begin
            reg [2:0] count;
            count = 3'b0;
            for (int x = -1; x <= 1; x++) begin
                for (int y = -1; y <= 1; y++) begin
                    if ((x == 0) && (y == 0)) begin
                        // Skip the current cell
                    end else begin
                        reg [7:0] j, k;
                        j = (i / 16) + x;
                        k = (i % 16) + y;
                        if (current_state[((j % 16) * 16) + (k % 16)]) begin
                            count = count + 1'b1;
                        end
                    end
                end
            end
            if (count <= 1 || count >= 4) begin
                next_state[i] <= 1'b0;
            end else if (count == 3) begin
                next_state[i] <= 1'b1;
            end else begin
                next_state[i] <= current_state[i];
            end
        end
        current_state <= next_state;
    end
    q <= current_state;
end

endmodule