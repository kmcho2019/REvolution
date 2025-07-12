module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

reg [2:0] state;  // current state
reg [2:0] next_state;  // next state

// State flip-flops
always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000;  // reset to state A
    end else begin
        state <= next_state;
    end
end

// State transition logic
always @(*) begin
    case (state)
        3'b000:  // state A
            if (w) begin
                next_state = 3'b001;  // go to state B
            end else begin
                next_state = 3'b000;  // stay in state A
            end
        3'b001:  // state B
            if (w) begin
                next_state = 3'b010;  // go to state C
            end else begin
                next_state = 3'b011;  // go to state D
            end
        3'b010:  // state C
            if (w) begin
                next_state = 3'b100;  // go to state E
            end else begin
                next_state = 3'b011;  // go to state D
            end
        3'b011:  // state D
            if (w) begin
                next_state = 3'b101;  // go to state F
            end else begin
                next_state = 3'b000;  // go to state A
            end
        3'b100:  // state E
            if (w) begin
                next_state = 3'b100;  // stay in state E
            end else begin
                next_state = 3'b011;  // go to state D
            end
        3'b101:  // state F
            if (w) begin
                next_state = 3'b010;  // go to state C
            end else begin
                next_state = 3'b011;  // go to state D
            end
        default: next_state = 3'b000;  // default to state A
    endcase
end

// Output logic
always @(*) begin
    case (state)
        3'b000, 3'b001, 3'b010, 3'b011: z = 0;  // states A, B, C, D
        3'b100: z = w;  // state E
        3'b101: z = w;  // state F
        default: z = 0;  // default output
    endcase
end

endmodule