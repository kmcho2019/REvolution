module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;
reg [511:0] next_state;

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    next_state = current_state;
    for (int i = 0; i < 512; i++) begin
        reg [2:0] neighbors;
        if (i == 0) begin
            neighbors[2] = 1'b0;
        end else begin
            neighbors[2] = current_state[i-1];
        end
        neighbors[1] = current_state[i];
        if (i == 511) begin
            neighbors[0] = 1'b0;
        end else begin
            neighbors[0] = current_state[i+1];
        end
        case (neighbors)
            3'b111: next_state[i] = 1'b0;
            3'b110: next_state[i] = 1'b1;
            3'b101: next_state[i] = 1'b1;
            3'b100: next_state[i] = 1'b0;
            3'b011: next_state[i] = 1'b1;
            3'b010: next_state[i] = 1'b1;
            3'b001: next_state[i] = 1'b1;
            3'b000: next_state[i] = 1'b0;
            default: next_state[i] = 1'bx;
        endcase
    end
end

assign q = current_state;

endmodule