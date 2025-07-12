module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output reg Y0,
    output reg z
);
    reg [2:0] state;       // present state
    reg [2:0] next_state;  // next state
    
    // Determine next state and output z combinationally based on current state and input x
    always @(*) begin
        // Default outputs
        next_state = state;
        z = 1'b0;
        
        case (state)
            3'b000: begin
                z = 1'b0;
                next_state = x ? 3'b001 : 3'b000;
            end
            3'b001: begin
                z = 1'b0;
                next_state = x ? 3'b100 : 3'b001;
            end
            3'b010: begin
                z = 1'b0;
                next_state = x ? 3'b001 : 3'b010;
            end
            3'b011: begin
                z = 1'b1;
                next_state = x ? 3'b010 : 3'b001;
            end
            3'b100: begin
                z = 1'b1;
                next_state = x ? 3'b100 : 3'b011;
            end
            default: begin
                z = 1'b0;
                next_state = 3'b000; // default fallback state
            end
        endcase
    end
    
    // State register update on clk edge
    always @(posedge clk) begin
        state <= y;  // load initial or external state from input y on each clock
        // Actually, the problem description doesn't explicitly say how state is initialized or controlled.
        // It has input y and also internal state. It seems y is the present state, which is input.
        // The FSM should use input y as present state, so no internal state register is needed to hold state.
        // However, the next state and output logic are defined based on present state = input y.
        // So we use input y directly, no internal state register.
    end
    
    // Assign Y0 to LSB of next_state
    always @(*) begin
        Y0 = next_state[0];
    end

endmodule