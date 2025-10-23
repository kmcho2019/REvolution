module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] current_state;
wire [255:0] next_state;

integer i, j;

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

genvar x, y;
generate
    for (x = 0; x < 16; x = x + 1) begin
        for (y = 0; y < 16; y = y + 1) begin
            wire [7:0] neighbors;
            assign neighbors[0] = current_state[(x-1+16)%16*16 + (y-1+16)%16];
            assign neighbors[1] = current_state[(x-1+16)%16*16 + y];
            assign neighbors[2] = current_state[(x-1+16)%16*16 + (y+1)%16];
            assign neighbors[3] = current_state[x*16 + (y-1+16)%16];
            assign neighbors[4] = current_state[x*16 + (y+1)%16];
            assign neighbors[5] = current_state[(x+1)%16*16 + (y-1+16)%16];
            assign neighbors[6] = current_state[(x+1)%16*16 + y];
            assign neighbors[7] = current_state[(x+1)%16*16 + (y+1)%16];

            reg alive;
            always @(current_state) begin
                alive = (current_state[x*16 + y] == 1'b1);
            end

            reg [2:0] count;
            always @(neighbors) begin
                count = 3'b0;
                for (integer i = 0; i < 8; i = i + 1) begin
                    if (neighbors[i] == 1'b1) begin
                        count = count + 1;
                    end
                end
            end

            assign next_state[x*16 + y] = (count == 3'b011) || (alive && count == 3'b010) ? 1'b1 : 1'b0;
        end
    end
endgenerate

assign q = current_state;

endmodule