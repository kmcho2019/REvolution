module TopModule(
    input  in,
    input  [1:0] state,
    output [1:0] next_state,
    output out
);

always @(*) begin
    case (state)
        2'b00: // State A
            if (!in) 
                next_state = 2'b00; // A
            else 
                next_state = 2'b01; // B
        2'b01: // State B
            if (!in) 
                next_state = 2'b10; // C
            else 
                next_state = 2'b01; // B
        2'b10: // State C
            if (!in) 
                next_state = 2'b00; // A
            else 
                next_state = 2'b11; // D
        2'b11: // State D
            if (!in) 
                next_state = 2'b10; // C
            else 
                next_state = 2'b01; // B
        default: next_state = 2'b00; // Default state
    endcase
    
    case (state)
        2'b00, 2'b01, 2'b10: out = 1'b0; // States A, B, C output 0
        2'b11: out = 1'b1; // State D output 1
        default: out = 1'b0; // Default output
    endcase
end

endmodule