module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] current_state;
reg [255:0] next_state;

assign q = current_state;

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

genvar i;
generate
    for (i = 0; i < 256; i = i + 1) begin : gen_next_state
        wire [7:0] neighbors;
        assign neighbors[0] = current_state[(i + 1) % 256]; // right
        assign neighbors[1] = current_state[(i + 16) % 256]; // down
        assign neighbors[2] = current_state[(i + 17) % 256]; // down-right
        assign neighbors[3] = current_state[(i - 1 + 256) % 256]; // left
        assign neighbors[4] = current_state[(i - 16 + 256) % 256]; // up
        assign neighbors[5] = current_state[(i - 17 + 256) % 256]; // up-left
        assign neighbors[6] = current_state[(i + 15) % 256]; // down-left
        assign neighbors[7] = current_state[(i - 15 + 256) % 256]; // up-right

        wire [2:0] alive_neighbors;
        assign alive_neighbors = neighbors[0] + neighbors[1] + neighbors[2] + neighbors[3] + neighbors[4] + neighbors[5] + neighbors[6] + neighbors[7];

        always @(*) begin
            case (alive_neighbors)
                3'd0, 3'd1: next_state[i] = 1'b0;
                3'd2: next_state[i] = current_state[i];
                3'd3: next_state[i] = 1'b1;
                default: next_state[i] = 1'b0;
            endcase
        end
    end
endgenerate

endmodule