module TopModule(
    input  in,
    input  [1:0] state,
    output [1:0] next_state,
    output out
);

    // State transition logic
    always @(state, in) begin
        case (state)
            2'b00: next_state = (in == 1'b0) ? 2'b00 : 2'b01;
            2'b01: next_state = (in == 1'b0) ? 2'b10 : 2'b01;
            2'b10: next_state = (in == 1'b0) ? 2'b00 : 2'b11;
            2'b11: next_state = (in == 1'b0) ? 2'b10 : 2'b01;
        endcase
    end

    // Output logic
    always @(state) begin
        case (state)
            2'b00, 2'b01, 2'b10: out = 1'b0;
            2'b11: out = 1'b1;
        endcase
    end

endmodule