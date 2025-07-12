module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] current_state;
reg [255:0] next_state;

integer i, j;
integer neighbors;

always @ (posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

always @ (*) begin
    next_state = 256'b0;
    for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
            neighbors = 0;
            for (integer k = -1; k <= 1; k = k + 1) begin
                for (integer l = -1; l <= 1; l = l + 1) begin
                    if ((k == 0) && (l == 0)) begin
                        continue;
                    end
                    integer row = (i + k + 16) % 16;
                    integer col = (j + l + 16) % 16;
                    integer index = row * 16 + col;
                    if (current_state[index]) begin
                        neighbors = neighbors + 1;
                    end
                end
            end
            integer index = i * 16 + j;
            if ((neighbors == 2) && current_state[index]) begin
                next_state[index] = 1'b1;
            end else if ((neighbors == 3) || ((neighbors == 2) && current_state[index] == 1'b0)) begin
                next_state[index] = 1'b1;
            end else begin
                next_state[index] = 1'b0;
            end
        end
    end
end

assign q = current_state;

endmodule