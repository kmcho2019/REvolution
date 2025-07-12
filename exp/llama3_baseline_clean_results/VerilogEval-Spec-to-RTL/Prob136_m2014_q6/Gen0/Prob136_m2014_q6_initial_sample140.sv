module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

reg [2:0] state;  // Use 3 bits to represent the states A to F
reg [2:0] next_state;  // Next state variable
wire z_wire;  // Intermediate wire for output z

// Output logic
assign z = z_wire;
assign z_wire = (state == 3'b100) || (state == 3'b101);

// Sequential logic
always @ (posedge clk or posedge reset) begin
    if (reset) begin
        state <= 3'b000;  // Reset to state A
    end else begin
        state <= next_state;
    end
end

// Combinational logic
always @ (*) begin
    case (state)
        3'b000: begin  // State A
            if (!w) begin
                next_state = 3'b001;  // Transition to B
            end else begin
                next_state = 3'b000;  // Stay in A
            end
        end
        3'b001: begin  // State B
            if (!w) begin
                next_state = 3'b010;  // Transition to C
            end else begin
                next_state = 3'b011;  // Transition to D
            end
        end
        3'b010: begin  // State C
            if (!w) begin
                next_state = 3'b100;  // Transition to E
            end else begin
                next_state = 3'b011;  // Transition to D
            end
        end
        3'b011: begin  // State D
            if (!w) begin
                next_state = 3'b101;  // Transition to F
            end else begin
                next_state = 3'b000;  // Transition to A
            end
        end
        3'b100: begin  // State E
            if (!w) begin
                next_state = 3'b100;  // Stay in E
            end else begin
                next_state = 3'b011;  // Transition to D
            end
        end
        3'b101: begin  // State F
            if (!w) begin
                next_state = 3'b010;  // Transition to C
            end else begin
                next_state = 3'b011;  // Transition to D
            end
        end
        default: begin
            next_state = 3'b000;  // Default to state A
        end
    endcase
end

endmodule