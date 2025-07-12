module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

reg [2:0] state, next_state;

// Output logic
assign z = (state == 3'b100); // Output is high when state is E (4)

// State encoding
// A: 000, B: 001, C: 010, D: 011, E: 100, F: 101

always @ (posedge clk) begin
    if (reset) begin
        state <= 3'b000; // Reset state to A
    end else begin
        state <= next_state;
    end
end

always @ (*) begin
    case (state)
        3'b000: // A
            if (w) begin
                next_state = 3'b000; // A
            end else begin
                next_state = 3'b001; // B
            end
        3'b001: // B
            if (w) begin
                next_state = 3'b011; // D
            end else begin
                next_state = 3'b010; // C
            end
        3'b010: // C
            if (w) begin
                next_state = 3'b011; // D
            end else begin
                next_state = 3'b100; // E
            end
        3'b011: // D
            if (w) begin
                next_state = 3'b000; // A
            end else begin
                next_state = 3'b110; // F
            end
        3'b100: // E
            if (w) begin
                next_state = 3'b011; // D
            end else begin
                next_state = 3'b100; // E
            end
        3'b101: // F
            if (w) begin
                next_state = 3'b011; // D
            end else begin
                next_state = 3'b010; // C
            end
        default: next_state = 3'b000;
    endcase
end

endmodule