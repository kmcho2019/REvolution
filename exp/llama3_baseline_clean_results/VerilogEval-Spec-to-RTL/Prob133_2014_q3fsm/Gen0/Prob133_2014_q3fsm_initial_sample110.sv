module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // Encoding states: A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11
reg [1:0] counter; // Counts w = 1 occurrences

always @(posedge clk) begin
    if(reset) begin
        state <= 2'b00; // Reset to state A
        z <= 1'b0;
        counter <= 2'b00;
    end else begin
        case(state)
            2'b00: begin // State A
                if(s) begin
                    state <= 2'b01; // Move to state B
                end
            end
            2'b01: begin // State B
                state <= 2'b10; // Move to state C
                counter <= 2'b00;
            end
            2'b10: begin // State C
                if(w) begin
                    counter <= counter + 1;
                    state <= 2'b11; // Move to state D
                end else begin
                    state <= 2'b10; // Stay in state C
                end
            end
            2'b11: begin // State D
                if(w) begin
                    counter <= counter + 1;
                    state <= 2'b10; // Move back to state C (E is implicit here as we decide z in the next cycle)
                end else begin
                    state <= 2'b10; // Stay in state C
                end
            end
        endcase
        
        // Decide z based on the previous state and counter
        if(state == 2'b10 && counter == 2) begin
            z <= 1'b1;
        end else begin
            z <= 1'b0;
        end
        
        // After deciding z, reset counter for the next cycle if necessary
        if(state == 2'b10) begin
            counter <= 2'b00;
        end
    end
end

endmodule