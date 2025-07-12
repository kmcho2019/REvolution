module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] next_q;

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                int n = 0;
                for (int x = -1; x <= 1; x++) begin
                    for (int y = -1; y <= 1; y++) begin
                        if (x == 0 && y == 0) continue;
                        int r = (i + x + 16) % 16;
                        int c = (j + y + 16) % 16;
                        n += q[r*16 + c];
                    end
                end
                if (n == 3 || (q[i*16 + j] == 1 && n == 2)) begin
                    next_q[i*16 + j] <= 1;
                end else begin
                    next_q[i*16 + j] <= 0;
                end
            end
        end
        q <= next_q;
    end
end

endmodule