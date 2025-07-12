module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg [1:0] state; // State machine states

always @(posedge clock) begin
    case (state)
        2'b00: begin // Initial state or 'p' and 'q' are low
            if (a) begin
                p <= 1'b1; // Set 'p' high when 'a' is high
                state <= 2'b01; // Transition to state where 'p' is high
            end
        end
        2'b01: begin // 'p' is high
            if (!a) begin
                p <= 1'b0; // Reset 'p' when 'a' goes low
                state <= 2'b00; // Return to initial state
            end else begin
                q <= 1'b1; // Set 'q' high if 'a' is still high
                state <= 2'b10; // Transition to state where 'q' is high
            end
        end
        2'b10: begin // 'q' is high
            if (!a && !clock) begin // If 'a' goes low and clock goes low
                q <= 1'b0; // Reset 'q'
                state <= 2'b00; // Return to initial state
            end
        end
        default: begin
            state <= 2'b00; // Default to initial state
        end
    endcase
end

always @(negedge clock) begin
    if (state == 2'b10 && !a) begin // If 'q' is high and 'a' goes low on falling clock edge
        q <= 1'b0; // Reset 'q'
        state <= 2'b00; // Return to initial state
    end
end

initial begin
    p = 1'b0;
    q = 1'b0;
    state = 2'b00;
end

endmodule