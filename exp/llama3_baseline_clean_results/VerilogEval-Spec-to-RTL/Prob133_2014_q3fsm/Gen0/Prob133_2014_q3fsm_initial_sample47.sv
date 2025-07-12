module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // States: 2'b00 - A, 2'b01 - B
reg [1:0] counter; // Counter for 3 clock cycles
reg w_count; // Flag to count w = 1 occurrences

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 2'b00; // Reset to state A
        counter <= 2'b00;
        w_count <= 1'b0;
        z <= 1'b0;
    end else begin
        case(state)
            2'b00: begin // State A
                if(s) begin
                    state <= 2'b01; // Move to state B when s = 1
                    counter <= 2'b00; // Reset counter
                    w_count <= 1'b0; // Reset w_count flag
                end
            end
            2'b01: begin // State B
                if(counter == 2'b11) begin // After 3 cycles
                    if(w_count == 2'b10) begin // If w = 1 exactly twice
                        z <= 1'b1; // Set z to 1
                    end else begin
                        z <= 1'b0; // Otherwise, z = 0
                    end
                    counter <= 2'b00; // Reset counter
                    w_count <= 1'b0; // Reset w_count
                end else begin
                    if(w) begin
                        w_count <= w_count + 1'b1; // Increment w_count if w = 1
                    end
                    counter <= counter + 1'b1; // Increment counter
                end
            end
        endcase
    end
end

endmodule