module TopModule(
    input  clk,
    input  load,
    input  [255:0] data,
    output [255:0] q
);

reg [255:0] current_state;

integer i, j, x, y, neighbors;

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        for (i = 0; i < 256; i++) begin
            x = i % 16;
            y = i / 16;
            neighbors = 0;
            for (j = 0; j < 8; j++) begin
                case (j)
                    0: begin // (x+1, y+1)
                        neighbors += current_state[((((y+1)%16)*16) + ((x+1)%16))];
                    end
                    1: begin // (x+1, y)
                        neighbors += current_state[((y*16) + ((x+1)%16))];
                    end
                    2: begin // (x+1, y-1)
                        neighbors += current_state[((((y-1)%16+16)%16)*16) + ((x+1)%16)];
                    end
                    3: begin // (x, y+1)
                        neighbors += current_state[((((y+1)%16)*16) + x)];
                    end
                    4: begin // (x, y-1)
                        neighbors += current_state[((((y-1)%16+16)%16)*16) + x];
                    end
                    5: begin // (x-1, y+1)
                        neighbors += current_state[((((y+1)%16)*16) + ((x-1)%16+16)%16)];
                    end
                    6: begin // (x-1, y)
                        neighbors += current_state[(y*16) + ((x-1)%16+16)%16];
                    end
                    7: begin // (x-1, y-1)
                        neighbors += current_state[((((y-1)%16+16)%16)*16) + ((x-1)%16+16)%16];
                    end
                endcase
            end
            if (neighbors < 2 || neighbors > 3) begin
                current_state[i] <= 0;
            end else if (neighbors == 3) begin
                current_state[i] <= 1;
            end
        end
    end
end

assign q = current_state;

endmodule