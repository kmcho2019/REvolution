module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;

integer i;

always @(*) begin
    for (i = 0; i < 512; i++) begin
        reg [2:0] neighbor_states;
        reg left, center, right;
        
        center = current_state[i];
        left = (i == 0)? 1'b0 : current_state[i - 1];
        right = (i == 511)? 1'b0 : current_state[i + 1];

        neighbor_states = {left, center, right};

        case (neighbor_states)
            3'b111: q[i] = 1'b0;
            3'b110: q[i] = 1'b1;
            3'b101: q[i] = 1'b1;
            3'b100: q[i] = 1'b0;
            3'b011: q[i] = 1'b1;
            3'b010: q[i] = 1'b1;
            3'b001: q[i] = 1'b1;
            3'b000: q[i] = 1'b0;
            default: q[i] = 1'bx;
        endcase
    end
end

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= q;
    end
end

endmodule