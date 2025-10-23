module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Define the states
reg [0:0] state;  // 0 for A, 1 for B

// State transition logic
always @(posedge clk) begin
    if (reset) begin
        state <= 1'b1;  // Reset to state B
    end else begin
        case (state)
            1'b0: begin  // State A
                if (!in) begin
                    state <= 1'b1;  // Transition to state B
                end
            end
            1'b1: begin  // State B
                if (!in) begin
                    state <= 1'b0;  // Transition to state A
                end
            end
        endcase
    end
end

// Output logic
always @(*) begin
    case (state)
        1'b0: begin  // State A
            out <= 1'b0;
        end
        1'b1: begin  // State B
            out <= 1'b1;
        end
    endcase
end

endmodule