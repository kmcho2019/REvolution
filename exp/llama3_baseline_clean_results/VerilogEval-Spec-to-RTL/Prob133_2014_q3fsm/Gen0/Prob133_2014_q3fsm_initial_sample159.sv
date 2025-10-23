module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // State A (2'b00) and State B (2'b01), additional states for counting
reg [1:0] count; // Counter for clock cycles
reg [1:0] w_count; // Counter for w occurrences

// Initialize state
initial begin
    state = 2'b00; // State A
    count = 2'b00;
    w_count = 2'b00;
    z = 1'b0;
end

always @(posedge clk) begin
    if (reset) begin
        state = 2'b00; // Reset to state A
        count = 2'b00;
        w_count = 2'b00;
        z = 1'b0;
    end else begin
        case (state)
            2'b00: begin // State A
                if (s) begin
                    state = 2'b01; // Move to state B
                    count = 2'b01; // Start counting clock cycles
                    w_count = w? 1'b1 : 1'b0; // Count w occurrences
                end
            end
            2'b01: begin // State B
                if (count < 3) begin // Within the three clock cycles
                    count = count + 1;
                    if (w) begin
                        w_count = w_count + 1;
                    end
                end else begin // After three clock cycles
                    if (w_count == 2) begin // Exactly two w = 1 occurrences
                        z = 1'b1;
                    end else begin
                        z = 1'b0;
                    end
                    // Reset counters and state for next sequence
                    count = 2'b01;
                    w_count = w? 1'b1 : 1'b0;
                end
            end
        endcase
    end
end

endmodule