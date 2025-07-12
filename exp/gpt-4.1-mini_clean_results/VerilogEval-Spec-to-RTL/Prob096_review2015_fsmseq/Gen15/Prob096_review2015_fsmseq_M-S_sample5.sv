module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

    // State encoding (2 bits):
    // 00: no match
    // 01: matched '1'
    // 10: matched "11"
    // 11: matched "1101" detected (latch here)
    reg [1:0] state, next_state;

    always @(posedge clk) begin
        if (reset)
            state <= 2'b00;
        else
            state <= next_state;
    end

    // Next-state logic
    always @(*) begin
        case (state)
            2'b00: next_state = data ? 2'b01 : 2'b00;
            2'b01: next_state = data ? 2'b10 : 2'b00;
            2'b10: next_state = data ? 2'b01 : 2'b11; // On '0', sequence "110" matched, next input completes "1101"
            2'b11: next_state = 2'b11; // latch detected state
            default: next_state = 2'b00;
        endcase
    end

    assign start_shifting = (state == 2'b11);

endmodule