module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

reg [1:0] state;
reg [1:0] next_state;

always_comb begin
    case (state)
        2'b00: next_state = in ? 2'b01 : 2'b00; // A
        2'b01: next_state = in ? 2'b01 : 2'b10; // B
        2'b10: next_state = in ? 2'b11 : 2'b00; // C
        2'b11: next_state = in ? 2'b01 : 2'b10; // D
        default: next_state = 2'b00;
    endcase
end

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00;
        out <= 0;
    end else begin
        state <= next_state;
        case (next_state)
            2'b00, 2'b01, 2'b10: out <= 0;
            2'b11: out <= 1;
            default: out <= 0;
        endcase
    end
end

endmodule