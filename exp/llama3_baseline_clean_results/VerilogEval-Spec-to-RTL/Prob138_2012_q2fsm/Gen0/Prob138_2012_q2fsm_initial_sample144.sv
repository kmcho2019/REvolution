module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

reg [2:0] state, next_state;

// State transition logic
always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000; // Reset to state A
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        3'b000: begin // State A
            if (w) begin
                next_state = 3'b001; // Go to state B
            end else begin
                next_state = 3'b000; // Stay in state A
            end
        end
        3'b001: begin // State B
            if (w) begin
                next_state = 3'b010; // Go to state C
            end else begin
                next_state = 3'b011; // Go to state D
            end
        end
        3'b010: begin // State C
            if (w) begin
                next_state = 3'b100; // Go to state E
            end else begin
                next_state = 3'b011; // Go to state D
            end
        end
        3'b011: begin // State D
            if (w) begin
                next_state = 3'b101; // Go to state F
            end else begin
                next_state = 3'b000; // Go to state A
            end
        end
        3'b100: begin // State E
            if (w) begin
                next_state = 3'b100; // Stay in state E
            end else begin
                next_state = 3'b011; // Go to state D
            end
        end
        3'b101: begin // State F
            if (w) begin
                next_state = 3'b010; // Go to state C
            end else begin
                next_state = 3'b011; // Go to state D
            end
        end
        default: begin
            next_state = 3'b000; // Default to state A
        end
    endcase
end

// Output logic
assign z = (state == 3'b100) || (state == 3'b101);

endmodule