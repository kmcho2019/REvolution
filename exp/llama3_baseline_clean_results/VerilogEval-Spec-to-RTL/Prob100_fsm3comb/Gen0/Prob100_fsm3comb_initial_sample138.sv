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
                next_state = 2'b00; // Next state is A when in=0
                out = 0;
            end else begin
                next_state = 2'b01; // Next state is B when in=1
                out = 0;
            end
        
        2'b01: // State B
            if (!in) begin
                next_state = 2'b10; // Next state is C when in=0
                out = 0;
            end else begin
                next_state = 2'b01; // Next state is B when in=1
                out = 0;
            end
        
        2'b10: // State C
            if (!in) begin
                next_state = 2'b00; // Next state is A when in=0
                out = 0;
            end else begin
                next_state = 2'b11; // Next state is D when in=1
                out = 0;
            end
        
        2'b11: // State D
            if (!in) begin
                next_state = 2'b10; // Next state is C when in=0
                out = 1;
            end else begin
                next_state = 2'b01; // Next state is B when in=1
                out = 1;
            end
        
        default: begin
            next_state = 2'b00; // Default next state
            out = 0;
        end
    endcase
end

endmodule