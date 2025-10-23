module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

reg [1:0] state; // State register, 2 bits for states A and B
reg [1:0] counter; // Counter for the 3-cycle window
reg w_count; // Counter for occurrences of w = 1
reg [1:0] next_state; // Next state register
reg next_counter; // Next value of counter
reg next_w_count; // Next value of w_count
reg next_z; // Next output z

// Initial state and reset logic
initial begin
    state = 2'b00; // State A
    counter = 2'b00;
    w_count = 1'b0;
    z = 1'b0;
end

always @(*) begin
    case(state)
        2'b00: begin // State A
            if(s) begin
                next_state = 2'b01; // Transition to state B
                next_counter = 2'b01; // Start counter
                next_w_count = 1'b0; // Reset w_count
                next_z = 1'b0; // Reset z
            end else begin
                next_state = 2'b00; // Stay in state A
                next_counter = 2'b00; // Reset counter
                next_w_count = 1'b0; // Reset w_count
                next_z = 1'b0; // Reset z
            end
        end
        2'b01: begin // State B
            if(counter == 2'b11) begin // End of 3-cycle window
                if(w_count == 2'b10) begin // Exactly two w = 1 occurrences
                    next_z = 1'b1; // Set z = 1 for next cycle
                end else begin
                    next_z = 1'b0; // Reset z
                end
                next_counter = 2'b01; // Reset counter
                next_w_count = 1'b0; // Reset w_count
            end else begin
                if(w) begin
                    next_w_count = w_count + 1'b1; // Increment w_count if w = 1
                end else begin
                    next_w_count = w_count; // Keep w_count if w = 0
                end
                next_counter = counter + 1'b1; // Increment counter
                next_z = 1'b0; // Reset z during counting
            end
            next_state = 2'b01; // Stay in state B
        end
        default: begin
            next_state = 2'b00;
            next_counter = 2'b00;
            next_w_count = 1'b0;
            next_z = 1'b0;
        end
    endcase
end

always @(posedge clk) begin
    if(reset) begin
        state <= 2'b00; // Reset to state A
        counter <= 2'b00;
        w_count <= 1'b0;
        z <= 1'b0;
    end else begin
        state <= next_state;
        counter <= next_counter;
        w_count <= next_w_count;
        z <= next_z;
    end
end

endmodule