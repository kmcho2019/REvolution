module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

reg [2:0] current_state, next_state;

// Initialize the current_state to A (000) when reset is high
always @(posedge reset or posedge clk) begin
    if (reset) begin
        current_state <= 3'b000; // A
    end else begin
        current_state <= next_state;
    end
end

// Combinational logic to determine the next_state
always @(*) begin
    case (current_state)
        3'b000: // A
            if (~w) begin
                next_state = 3'b001; // B
            end else begin
                next_state = 3'b000; // A
            end
        3'b001: // B
            if (~w) begin
                next_state = 3'b010; // C
            end else begin
                next_state = 3'b011; // D
            end
        3'b010: // C
            if (~w) begin
                next_state = 3'b100; // E
            end else begin
                next_state = 3'b011; // D
            end
        3'b011: // D
            if (~w) begin
                next_state = 3'b101; // F
            end else begin
                next_state = 3'b000; // A
            end
        3'b100: // E
            if (w) begin
                next_state = 3'b100; // E
            end else begin
                next_state = 3'b011; // D
            end
        3'b101: // F
            if (w) begin
                next_state = 3'b101; // F
            end else begin
                next_state = 3'b010; // C
            end
        default: next_state = 3'b000; // A
    endcase
end

// Combinational logic to determine the output z
assign z = (current_state == 3'b100) || (current_state == 3'b101); // z = 1 when current_state is E or F

endmodule