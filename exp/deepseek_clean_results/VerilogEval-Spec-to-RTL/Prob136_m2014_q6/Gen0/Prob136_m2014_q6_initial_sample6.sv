module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

// Define states
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

reg [2:0] current_state, next_state;

// State transition logic
always @(posedge clk) begin
    if (reset)
        current_state <= A;
    else
        current_state <= next_state;
end

// Next state and output logic
always @(*) begin
    case (current_state)
        A: begin
            z = 0;
            next_state = w ? A : B;
        end
        B: begin
            z = 0;
            next_state = w ? D : C;
        end
        C: begin
            z = 0;
            next_state = w ? D : E;
        end
        D: begin
            z = 0;
            next_state = w ? A : F;
        end
        E: begin
            z = 1;
            next_state = w ? D : E;
        end
        F: begin
            z = 1;
            next_state = w ? D : C;
        end
        default: begin
            z = 0;
            next_state = A;
        end
    endcase
end

endmodule