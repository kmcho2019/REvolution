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
    for (i = 0; i < 256; i = i + 1) begin
        wire [3:0] neighbors;
        assign neighbors = count_neighbors(current_state, i / 16, i % 16);
        always @(*) begin
            if (load) begin
                next_state[i] <= data[i];
            end else begin
                case (neighbors)
                    4'b0000, 4'b0001: next_state[i] <= 1'b0;
                    4'b0010: next_state[i] <= current_state[i];
                    4'b0011: next_state[i] <= 1'b1;
                    default: next_state[i] <= 1'b0;
                endcase
            end
        end
    end
endgenerate

endmodule

module count_neighbors(
    input [255:0] state,
    input [3:0] x,
    input [3:0] y,
    output [3:0] count
);

reg [3:0] count_reg;
assign count = count_reg;

always @(*) begin
    count_reg = 0;
    for (int i = -1; i <= 1; i = i + 1) begin
        for (int j = -1; j <= 1; j = j + 1) begin
            if (i == 0 && j == 0) begin
                continue;
            end
            if (state[((x + i) % 16) * 16 + ((y + j) % 16)]) begin
                count_reg = count_reg + 1;
            end
        end
    end
end

endmodule