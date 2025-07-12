module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // State A = 2'b00, State B = 2'b01
reg [1:0] counter; // Combined counter for three clock cycles and w occurrences
reg w_count; // Counter for w = 1 occurrences

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
                    state <= 2'b01; // Transition to state B
                    counter <= 2'b01; // Start counter
                    w_count <= 1'b0; // Reset w counter
                end
            end
            2'b01: begin // State B
                if(w) begin
                    w_count <= w_count + 1'b1; // Increment w counter if w = 1
                end
                if(counter == 2'b11) begin // End of three clock cycles
                    if(w_count == 2'b10) begin // Exactly two w = 1 occurrences
                        z <= 1'b1;
                    end else begin
                        z <= 1'b0;
                    end
                    counter <= 2'b01; // Reset counter to start next window
                    w_count <= 1'b0; // Reset w counter
                end else begin
                    counter <= counter + 1'b1; // Increment counter
                end
            end
        endcase
    end
end

endmodule