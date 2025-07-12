module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // State transition logic
    always @(*) begin
        case(state)
            4'b0001: next_state = (in == 0) ? 4'b0001 : 4'b0010;
            4'b0010: next_state = (in == 0) ? 4'b0100 : 4'b0010;
            4'b0100: next_state = (in == 0) ? 4'b0001 : 4'b1000;
            4'b1000: next_state = (in == 0) ? 4'b0100 : 4'b0010;
            default: next_state = 4'bxxxx; // Invalid state
        endcase
    end

    // Output logic
    always @(*) begin
        case(state)
            4'b0001, 4'b0010, 4'b0100: out = 0;
            4'b1000: out = 1;
            default: out = 1'bx; // Invalid state
        endcase
    end

endmodule