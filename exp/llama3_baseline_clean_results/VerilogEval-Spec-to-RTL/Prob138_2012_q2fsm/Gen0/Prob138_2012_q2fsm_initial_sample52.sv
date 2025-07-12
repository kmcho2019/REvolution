module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

reg [2:0] currentState;
wire [2:0] nextState;

// State table
always @(*) begin
    case (currentState)
        3'b000: // A
            if (w) begin
                nextState = 3'b001; // A -> B
            end else begin
                nextState = 3'b000; // A -> A
            end
        3'b001: // B
            if (w) begin
                nextState = 3'b010; // B -> C
            end else begin
                nextState = 3'b011; // B -> D
            end
        3'b010: // C
            if (w) begin
                nextState = 3'b100; // C -> E
            end else begin
                nextState = 3'b011; // C -> D
            end
        3'b011: // D
            if (w) begin
                nextState = 3'b101; // D -> F
            end else begin
                nextState = 3'b000; // D -> A
            end
        3'b100: // E
            if (w) begin
                nextState = 3'b100; // E -> E
            end else begin
                nextState = 3'b011; // E -> D
            end
        3'b101: // F
            if (w) begin
                nextState = 3'b010; // F -> C
            end else begin
                nextState = 3'b011; // F -> D
            end
        default:
            nextState = 3'b000; // Default state
    endcase
end

// State flip-flops
always @(posedge clk or posedge reset) begin
    if (reset) begin
        currentState <= 3'b000; // Reset to state A
    end else begin
        currentState <= nextState;
    end
end

// Output logic
assign z = (currentState == 3'b100 && w) || (currentState == 3'b101 && w);

endmodule