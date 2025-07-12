module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg [1:0] state;
reg initialized;

always @(posedge clock) begin
    if (!initialized) begin
        state <= 2'b00;     // Initialize state at first clock
        initialized <= 1'b1;
    end else begin
        case (state)
            2'b00: state <= (a) ? 2'b01 : 2'b00;
            2'b01: state <= (a) ? 2'b11 : 2'b00;
            2'b11: state <= (a) ? 2'b11 : 2'b10;
            2'b10: state <= (a) ? 2'b11 : 2'b10;
            default: state <= 2'b00;
        endcase
    end
end

always @* begin
    p = state[0];
    q = state[1];
end

endmodule