module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

reg [2:0] currentState, nextState;

// Define the next state logic
always @(*)
begin
    case(currentState)
        3'b000: // State A
            if(w) begin
                nextState = 3'b001; // State B
            end else begin
                nextState = 3'b000; // State A
            end
        3'b001: // State B
            if(w) begin
                nextState = 3'b010; // State C
            end else begin
                nextState = 3'b011; // State D
            end
        3'b010: // State C
            if(w) begin
                nextState = 3'b100; // State E
            end else begin
                nextState = 3'b011; // State D
            end
        3'b011: // State D
            if(w) begin
                nextState = 3'b101; // State F
            end else begin
                nextState = 3'b000; // State A
            end
        3'b100: // State E
            if(w) begin
                nextState = 3'b100; // State E
            end else begin
                nextState = 3'b011; // State D
            end
        3'b101: // State F
            if(w) begin
                nextState = 3'b010; // State C
            end else begin
                nextState = 3'b011; // State D
            end
        default:
            nextState = 3'b000; // State A
    endcase
end

// Update the current state
always @(posedge clk)
begin
    if(reset) begin
        currentState <= 3'b000; // Reset to State A
    end else begin
        currentState <= nextState;
    end
end

// Define the output 'z'
assign z = (currentState == 3'b100) || (currentState == 3'b101);

endmodule