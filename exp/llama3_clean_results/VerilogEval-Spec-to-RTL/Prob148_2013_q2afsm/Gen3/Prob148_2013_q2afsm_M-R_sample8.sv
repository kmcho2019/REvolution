module TopModule (
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// Define state codes
reg [1:0] state;

// State machine
always @(posedge clk) begin
    if (~resetn) begin
        state <= 2'b00;  // Reset to state A
    end else begin
        case (state)
            2'b00:  // State A
                if (r[0]) begin
                    state <= 2'b01;  // Go to state B
                end else if (r[1]) begin
                    state <= 2'b10;  // Go to state C
                end else if (r[2]) begin
                    state <= 2'b11;  // Go to state D
                end else begin
                    state <= 2'b00;  // Stay in state A
                end
            2'b01:  // State B
                state <= r[0] ? 2'b01 : 2'b00;  // Stay in state B or go back to state A
            2'b10:  // State C
                state <= r[1] ? 2'b10 : 2'b00;  // Stay in state C or go back to state A
            2'b11:  // State D
                state <= r[2] ? 2'b11 : 2'b00;  // Stay in state D or go back to state A
            default:
                state <= 2'b00;  // Default to state A
        endcase
    end
end

// Assign output signals g[0], g[1], and g[2] based on the current state
always @(*) begin
    case (state)
        2'b00:  // State A
            g <= 3'b000;
        2'b01:  // State B
            g <= 3'b100;
        2'b10:  // State C
            g <= 3'b010;
        2'b11:  // State D
            g <= 3'b001;
        default:
            g <= 3'b000;  // Default to 0
    endcase
end

endmodule