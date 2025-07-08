module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);
    reg [2:0] next_state;
    
    // Combinational next state and output logic
    always @(*) begin
        case (y)
            3'b000: begin
                if (x == 0)
                    next_state = 3'b000;
                else
                    next_state = 3'b001;
            end
            3'b001: begin
                if (x == 0)
                    next_state = 3'b001;
                else
                    next_state = 3'b100;
            end
            3'b010: begin
                if (x == 0)
                    next_state = 3'b010;
                else
                    next_state = 3'b001;
            end
            3'b011: begin
                if (x == 0)
                    next_state = 3'b001;
                else
                    next_state = 3'b010;
            end
            3'b100: begin
                if (x == 0)
                    next_state = 3'b011;
                else
                    next_state = 3'b100;
            end
            default: begin
                // Default next state if state is outside defined states
                next_state = 3'b000;
            end
        endcase
    end
    
    // Output z logic based on present state and input x
    // According to the table:
    // z=1 for states 011 and 100 regardless of x
    // z=0 otherwise
    assign z = (y == 3'b011) || (y == 3'b100) ? 1'b1 : 1'b0;
    
    // Output Y0 is LSB of next_state
    assign Y0 = next_state[0];
    
endmodule