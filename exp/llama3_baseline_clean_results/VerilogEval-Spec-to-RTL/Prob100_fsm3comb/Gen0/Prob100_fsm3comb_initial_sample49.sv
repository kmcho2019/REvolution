module TopModule(
    input  in,
    input  [1:0] state,
    output [1:0] next_state,
    output out
);

always @(*) begin
    case (state)
        2'b00: // State A
            if (!in) begin
                next_state = 2'b00; // Next state is A
                out = 1'b0; // Output is 0
            end
            else begin
                next_state = 2'b01; // Next state is B
                out = 1'b0; // Output is 0
            end
        2'b01: // State B
            if (!in) begin
                next_state = 2'b10; // Next state is C
                out = 1'b0; // Output is 0
            end
            else begin
                next_state = 2'b01; // Next state is B
                out = 1'b0; // Output is 0
            end
        2'b10: // State C
            if (!in) begin
                next_state = 2'b00; // Next state is A
                out = 1'b0; // Output is 0
            end
            else begin
                next_state = 2'b11; // Next state is D
                out = 1'b0; // Output is 0
            end
        2'b11: // State D
            if (!in) begin
                next_state = 2'b10; // Next state is C
                out = 1'b1; // Output is 1
            end
            else begin
                next_state = 2'b01; // Next state is B
                out = 1'b1; // Output is 1
            end
    endcase
end

endmodule