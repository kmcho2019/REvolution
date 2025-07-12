module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

// Define the states
reg [2:0] state;
reg [2:0] next_state;

// Output z is always 1 in states E and F, and 0 in states A, B, C, and D
assign z = (state == 3'b100) | (state == 3'b101);

// Always block for state register
always @ (posedge clk or posedge reset) begin
    if (reset) begin
        state <= 3'b000;  // Reset state to A
    end else begin
        state <= next_state;
    end
end

// Always block for next state logic
always @ (*) begin
    case (state)
        3'b000:  // State A
            if (w) begin
                next_state = 3'b000;  // Stay in A
            end else begin
                next_state = 3'b001;  // Go to B
            end
        3'b001:  // State B
            if (w) begin
                next_state = 3'b011;  // Go to D
            end else begin
                next_state = 3'b010;  // Go to C
            end
        3'b010:  // State C
            if (w) begin
                next_state = 3'b011;  // Go to D
            end else begin
                next_state = 3'b100;  // Go to E
            end
        3'b011:  // State D
            if (w) begin
                next_state = 3'b000;  // Go to A
            end else begin
                next_state = 3'b101;  // Go to F
            end
        3'b100:  // State E
            if (w) begin
                next_state = 3'b011;  // Go to D
            end else begin
                next_state = 3'b100;  // Stay in E
            end
        3'b101:  // State F
            if (w) begin
                next_state = 3'b011;  // Go to D
            end else begin
                next_state = 3'b010;  // Go to C
            end
        default:  // Unused states
            next_state = 3'b000;  // Go to A
    endcase
end

endmodule