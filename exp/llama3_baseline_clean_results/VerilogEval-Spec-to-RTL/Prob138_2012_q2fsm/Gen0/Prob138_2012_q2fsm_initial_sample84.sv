module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

reg [2:0] currentState;
reg [2:0] nextState;

// State flip-flops
always @(posedge clk) begin
    if (reset) begin
        currentState <= 3'b000; // Reset to state A
    end else begin
        currentState <= nextState;
    end
end

// State table
always @(*) begin
    case (currentState)
        3'b000: // State A
            if (w) begin
                nextState <= 3'b001; // Next state is B
            end else begin
                nextState <= 3'b000; // Next state is A
            end
        3'b001: // State B
            if (w) begin
                nextState <= 3'b010; // Next state is C
            end else begin
                nextState <= 3'b011; // Next state is D
            end
        3'b010: // State C
            if (w) begin
                nextState <= 3'b100; // Next state is E
            end else begin
                nextState <= 3'b011; // Next state is D
            end
        3'b011: // State D
            if (w) begin
                nextState <= 3'b101; // Next state is F
            end else begin
                nextState <= 3'b000; // Next state is A
            end
        3'b100: // State E
            if (w) begin
                nextState <= 3'b100; // Next state is E
            end else begin
                nextState <= 3'b011; // Next state is D
            end
        3'b101: // State F
            if (w) begin
                nextState <= 3'b010; // Next state is C
            end else begin
                nextState <= 3'b011; // Next state is D
            end
        default:
            nextState <= 3'b000; // Default next state is A
    endcase
end

// FSM output z
always @(*) begin
    case (currentState)
        3'b100, 3'b101: // States E and F
            z <= 1'b1;
        default:
            z <= 1'b0;
    endcase
end

endmodule