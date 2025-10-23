module TopModule(
    input  clk,
    input  reset,
    input  w,
    output reg z // Declare z as a reg for procedural assignment
);

// Define the states
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// Define the current state and next state
reg [2:0] current_state;
reg [2:0] next_state;

// Sequential process
always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= A; // Reset to state A
    end else begin
        current_state <= next_state;
    end
end

// Combinational process
always @(*) begin
    case (current_state)
        A: begin
            next_state = w ? A : B;
            z = 0;
        end
        B: begin
            next_state = w ? D : C;
            z = 0;
        end
        C: begin
            next_state = w ? D : E;
            z = 0;
        end
        D: begin
            next_state = w ? A : F;
            z = 0;
        end
        E: begin
            next_state = w ? D : E;
            z = 1;
        end
        F: begin
            next_state = w ? D : C;
            z = 1;
        end
        default: begin
            next_state = A; // Default to state A
            z = 0;
        end
    endcase
end

endmodule