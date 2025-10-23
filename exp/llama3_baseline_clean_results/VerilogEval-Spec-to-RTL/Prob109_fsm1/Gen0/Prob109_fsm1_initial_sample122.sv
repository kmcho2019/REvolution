module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

reg [1:0] state;

always @(*) begin
    if (areset) begin
        state = 2'b01; // reset to state B
    end
end

always @(posedge clk) begin
    case (state)
        2'b01: // state B
            if (in == 1'b0) begin
                state <= 2'b00; // transition to state A
            end else begin
                state <= 2'b01; // stay in state B
            end
        2'b00: // state A
            if (in == 1'b0) begin
                state <= 2'b01; // transition to state B
            end else begin
                state <= 2'b00; // stay in state A
            end
        default:
            state <= 2'b01;
    endcase
end

always @(*) begin
    case (state)
        2'b01: // state B
            out = 1'b1;
        2'b00: // state A
            out = 1'b0;
        default:
            out = 1'b1;
    endcase
end

endmodule