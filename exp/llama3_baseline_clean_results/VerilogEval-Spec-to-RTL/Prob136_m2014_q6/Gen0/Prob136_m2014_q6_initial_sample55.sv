module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define states
parameter A = 6'd0,
           B = 6'd1,
           C = 6'd2,
           D = 6'd3,
           E = 6'd4,
           F = 6'd5;

reg [5:0] state; // Current state
reg [5:0] next_state; // Next state

// Combinational logic to determine next state
always @(*) begin
    case(state)
        A: next_state = (w == 1'b1)? A : B;
        B: next_state = (w == 1'b1)? D : C;
        C: next_state = (w == 1'b1)? D : E;
        D: next_state = (w == 1'b1)? A : F;
        E: next_state = (w == 1'b1)? D : E;
        F: next_state = (w == 1'b1)? D : C;
        default: next_state = A; // Default state
    endcase
end

// Sequential logic to update state on positive edge of clock
always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= A;
        z <= 1'b0; // Initialize z to 0 on reset
    end else begin
        state <= next_state;
        // Determine z based on state
        if(state == E || state == F) begin
            z <= 1'b1;
        end else begin
            z <= 1'b0;
        end
    end
end

endmodule