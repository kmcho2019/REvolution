module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

reg [2:0] currentState, nextState;
always @(posedge clk or posedge reset) begin
    if(reset) begin
        currentState <= 3'b000; // initialize to state A
    end else begin
        currentState <= nextState;
    end
end

always @(*) begin
    case(currentState)
        3'b000: // A
            if(w) begin
                nextState = 3'b000; // stay in A
            end else begin
                nextState = 3'b001; // go to B
            end
        3'b001: // B
            if(w) begin
                nextState = 3'b011; // go to D
            end else begin
                nextState = 3'b010; // go to C
            end
        3'b010: // C
            if(w) begin
                nextState = 3'b011; // go to D
            end else begin
                nextState = 3'b100; // go to E
            end
        3'b011: // D
            if(w) begin
                nextState = 3'b000; // go to A
            end else begin
                nextState = 3'b101; // go to F
            end
        3'b100: // E
            if(w) begin
                nextState = 3'b011; // go to D
            end else begin
                nextState = 3'b100; // stay in E
            end
        3'b101: // F
            if(w) begin
                nextState = 3'b011; // go to D
            end else begin
                nextState = 3'b010; // go to C
            end
        default: nextState = 3'b000; // default to A
    endcase
end

always @(*) begin
    case(currentState)
        3'b100, 3'b101: z = 1'b1; // E and F output 1
        default: z = 1'b0; // all other states output 0
    endcase
end

endmodule