module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

    reg [1:0] state;

    always @(posedge clock) begin
        case (state)
            2'b00: state <= a ? 2'b01 : 2'b00;
            2'b01: state <= a ? 2'b11 : 2'b01;
            2'b11: state <= a ? 2'b11 : 2'b01;
            2'b10: state <= 2'b00; // not seen in waveform, safe default
            default: state <= 2'b00;
        endcase
    end

    always @(*) begin
        // p is bit 0 of state, q is bit 1
        p = state[0];
        q = state[1];
    end

    initial begin
        state = 2'b00;
        p = 0;
        q = 0;
    end

endmodule