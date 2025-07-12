module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    reg [2:0] current_state, next_state;

    // State transition logic
    always @(*) begin
        case (current_state)
            3'b000: next_state = w ? 3'b001 : 3'b000;  // A
            3'b001: next_state = w ? 3'b011 : 3'b010;   // B
            3'b011: next_state = w ? 3'b110 : 3'b010;   // C
            3'b010: next_state = w ? 3'b100 : 3'b000;   // D
            3'b110: next_state = w ? 3'b110 : 3'b010;   // E
            3'b100: next_state = w ? 3'b011 : 3'b010;   // F
        endcase
    end

    // State storage with reset
    always @(posedge clk) begin
        current_state <= reset ? 3'b000 : next_state;
    end

    // Output logic
    assign z = current_state[2];

endmodule