module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // 2-bit state variable (0: State A, 1: State B)
reg [1:0] window_counter; // 2-bit counter for three clock cycles
reg [1:0] w_count; // 2-bit signal to track w occurrences

// Sequential logic
always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 2'b00; // Reset to state A
        window_counter <= 2'b00;
        w_count <= 2'b00;
        z <= 1'b0;
    end else begin
        case(state)
            2'b00: begin // State A
                if(s) begin
                    state <= 2'b01; // Transition to state B
                    window_counter <= 2'b00;
                    w_count <= 2'b00;
                end
            end
            2'b01: begin // State B
                if(window_counter == 2'b11) begin // End of window
                    window_counter <= 2'b00;
                    w_count <= 2'b00; // Reset w_count for the next window
                    if(w_count == 2'b10) begin // Exactly two 'w' occurrences
                        z <= 1'b1;
                    end else begin
                        z <= 1'b0;
                    end
                end else begin
                    window_counter <= window_counter + 1'b1;
                    if(w) begin
                        w_count <= w_count + 1'b1;
                    end
                end
            end
            default: state <= 2'b00; // Default state A
        endcase
    end
end

endmodule