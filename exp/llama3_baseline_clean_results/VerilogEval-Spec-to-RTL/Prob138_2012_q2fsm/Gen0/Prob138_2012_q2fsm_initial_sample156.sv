module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

reg [2:0] state, next_state;

// State flip-flops
always @(posedge clk) begin
    if(reset) begin
        state <= 0; // Reset to state A
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case(state)
        0: begin // State A
            if(w) begin
                next_state = 1; // A -> B
            end else begin
                next_state = 0; // A -> A
            end
        end
        1: begin // State B
            if(w) begin
                next_state = 2; // B -> C
            end else begin
                next_state = 3; // B -> D
            end
        end
        2: begin // State C
            if(w) begin
                next_state = 4; // C -> E
            end else begin
                next_state = 3; // C -> D
            end
        end
        3: begin // State D
            if(w) begin
                next_state = 5; // D -> F
            end else begin
                next_state = 0; // D -> A
            end
        end
        4: begin // State E
            if(w) begin
                next_state = 4; // E -> E
            end else begin
                next_state = 3; // E -> D
            end
        end
        5: begin // State F
            if(w) begin
                next_state = 2; // F -> C
            end else begin
                next_state = 3; // F -> D
            end
        end
        default: next_state = 0;
    endcase
end

// Output logic
always @(*) begin
    case(state)
        0, 1, 2, 3: z = 0; // States A, B, C, D
        4, 5: z = 1; // States E, F
        default: z = 0;
    endcase
end

endmodule