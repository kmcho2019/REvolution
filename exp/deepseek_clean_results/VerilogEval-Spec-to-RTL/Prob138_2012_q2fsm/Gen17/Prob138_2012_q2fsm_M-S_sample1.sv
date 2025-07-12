module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    reg [2:0] state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            3'b000: next_state = w ? 3'b001 : 3'b000; // A
            3'b001: next_state = w ? 3'b011 : 3'b010; // B
            3'b011: next_state = w ? 3'b110 : 3'b010; // C
            3'b010: next_state = w ? 3'b111 : 3'b000; // D
            3'b110: next_state = w ? 3'b110 : 3'b010; // E
            3'b111: next_state = w ? 3'b011 : 3'b010; // F
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= 3'b000;
        else
            state <= next_state;
    end

    // Output z is high in states E (110) and F (111)
    assign z = state[2];

endmodule