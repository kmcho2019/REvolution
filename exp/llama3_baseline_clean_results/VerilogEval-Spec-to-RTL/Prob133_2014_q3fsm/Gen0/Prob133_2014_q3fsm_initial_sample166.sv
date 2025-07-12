module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state = 2'b00; // 2'b00: State A, 2'b01: State B, Others: unused
reg [1:0] counter = 2'b00; // Counter for 3 clock cycles
reg [1:0] w_count = 2'b00; // Counter for w=1 occurrences

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to state A
        counter <= 2'b00;
        w_count <= 2'b00;
        z <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // State A
                if (s) begin
                    state <= 2'b01; // Transition to state B
                    counter <= 2'b01; // Start counter
                    w_count <= 2'b00; // Reset w counter
                end
            end
            2'b01: begin // State B
                if (w) begin
                    w_count <= w_count + 1'b1; // Increment w counter if w=1
                end
                if (counter == 2'b11) begin // End of 3-clock cycle window
                    counter <= 2'b00; // Reset counter
                    if (w_count == 2'b10) begin // w=1 exactly twice
                        z <= 1'b1; // Set z to 1
                    end else begin
                        z <= 1'b0; // Set z to 0
                    end
                    w_count <= 2'b00; // Reset w counter for next window
                end else begin
                    counter <= counter + 1'b1; // Increment counter
                    z <= 1'b0; // z remains 0 during counting
                end
            end
            default: state <= 2'b00; // Unused states default to A
        endcase
    end
end

endmodule