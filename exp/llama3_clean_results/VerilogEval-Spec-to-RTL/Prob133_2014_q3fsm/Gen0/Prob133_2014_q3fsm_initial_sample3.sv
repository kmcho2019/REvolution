module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // State A = 2'b00, State B = 2'b01, counter states = 2'b10, 2'b11
reg [1:0] count; // Counter for clock cycles
reg [1:0] w_count; // Counter for w = 1 occurrences

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 2'b00; // Reset to state A
        count <= 2'b00;
        w_count <= 2'b00;
        z <= 1'b0;
    end else begin
        case(state)
            2'b00: begin // State A
                if(s) begin
                    state <= 2'b01; // Move to state B
                    count <= 2'b01; // Start counter
                    w_count <= 2'b00; // Reset w counter
                end else begin
                    state <= 2'b00; // Stay in state A
                end
            end
            2'b01: begin // State B
                if(count == 2'b11) begin // End of 3 clock cycles
                    if(w_count == 2'b10) begin // Exactly two w = 1 occurrences
                        z <= 1'b1;
                    end else begin
                        z <= 1'b0;
                    end
                    state <= 2'b10; // Move to intermediate state to reset counters
                end else begin
                    if(w) begin
                        w_count <= w_count + 1'b1; // Increment w counter if w = 1
                    end
                    count <= count + 1'b1; // Increment clock cycle counter
                end
            end
            2'b10: begin // Intermediate state to reset counters
                state <= 2'b01; // Move back to state B
                count <= 2'b01; // Reset clock cycle counter
                w_count <= 2'b00; // Reset w counter
            end
            default: begin
                state <= 2'b00; // Default back to state A
            end
        endcase
    end
end

endmodule