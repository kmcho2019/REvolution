module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

reg [1:0] state; // 0: IDLE, 1: LOAD, 2: SHIFT

always @(posedge clk) begin
    case(state)
        2'b00: // IDLE
            if (L) begin
                Q <= R;
                state <= 2'b01; // LOAD
            end else if (E) begin
                Q <= w;
                state <= 2'b10; // SHIFT
            end
        2'b01: // LOAD
            state <= 2'b00; // IDLE
        2'b10: // SHIFT
            if (~E) begin
                state <= 2'b00; // IDLE
            end else begin
                Q <= w;
            end
        default: state <= 2'b00; // IDLE
    endcase
end

endmodule