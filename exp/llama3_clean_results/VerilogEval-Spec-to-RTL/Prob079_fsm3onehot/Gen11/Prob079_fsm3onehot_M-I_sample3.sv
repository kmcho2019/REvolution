module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Output logic
    assign out = state[3]; // Directly use the most significant bit for output

    // State transition logic using case statement
    always @(*) begin
        case (state)
            4'b0001: next_state = in ? 4'b0010 : 4'b0001;
            4'b0010: next_state = in ? 4'b0010 : 4'b0100;
            4'b0100: next_state = in ? 4'b1000 : 4'b0001;
            4'b1000: next_state = in ? 4'b0010 : 4'b0100;
            default: next_state = 4'bxxxx;
        endcase
    end

endmodule