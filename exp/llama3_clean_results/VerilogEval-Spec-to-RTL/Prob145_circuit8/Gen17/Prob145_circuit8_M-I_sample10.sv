module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg [1:0] state; // State machine to track 'a'

always @(posedge clock) begin
    case (state)
        2'b00: begin // 'a' was low in the previous clock cycle
            if (a) begin
                p <= 1'b1; // Set 'p' high when 'a' becomes high
                state <= 2'b01; // Transition to the state where 'a' is high for one clock cycle
            end else begin
                p <= 1'b0; // Keep 'p' low when 'a' is low
            end
            q <= 1'b0; // 'q' is low when 'a' has not been high for two consecutive clock cycles
        end
        2'b01: begin // 'a' has been high for one clock cycle
            if (a) begin
                state <= 2'b10; // Transition to the state where 'a' is high for two consecutive clock cycles
            end else begin
                state <= 2'b00; // Transition back to the initial state if 'a' becomes low
            end
            p <= a; // 'p' follows 'a' when 'a' has been high for one clock cycle
            q <= 1'b0; // 'q' remains low until 'a' has been high for two consecutive clock cycles
        end
        2'b10: begin // 'a' has been high for two consecutive clock cycles
            p <= a; // 'p' follows 'a'
            q <= a; // 'q' follows 'a' when 'a' has been high for two consecutive clock cycles
            if (!a) begin // If 'a' becomes low, reset the state
                state <= 2'b00;
            end
        end
        default: begin
            state <= 2'b00; // Reset to the initial state for any other condition
            p <= 1'b0;
            q <= 1'b0;
        end
    endcase
end

endmodule