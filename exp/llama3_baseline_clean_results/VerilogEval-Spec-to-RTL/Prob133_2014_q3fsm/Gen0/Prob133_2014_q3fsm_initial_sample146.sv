module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

reg [1:0] state; // 2 states: A (2'b00) and B (2'b01)
reg [1:0] counter; // counter for the number of clock cycles since the FSM entered state B
reg [1:0] w_counter; // counter for the number of times w = 1 in the three clock cycles
reg z_reg; // register for output z

// Initialize the state, counters, and output z
initial begin
    state = 2'b00; // initial state is A
    counter = 2'b00;
    w_counter = 2'b00;
    z_reg = 1'b0;
end

always @ (posedge clk) begin
    if (reset) begin
        // Reset the state, counters, and output z
        state <= 2'b00;
        counter <= 2'b00;
        w_counter <= 2'b00;
        z_reg <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // State A
                if (s) begin
                    // Move to state B
                    state <= 2'b01;
                    counter <= 2'b01; // increment counter
                    w_counter <= w ? 2'b01 : 2'b00; // increment w_counter if w = 1
                end else begin
                    // Stay in state A
                    state <= 2'b00;
                end
            end
            2'b01: begin // State B
                if (counter == 2'b11) begin
                    // Three clock cycles have passed, set output z and reset counters
                    z_reg <= (w_counter == 2'b10) ? 1'b1 : 1'b0; // set z to 1 if w_counter is 2
                    counter <= 2'b01; // reset counter
                    w_counter <= w ? 2'b01 : 2'b00; // reset w_counter
                end else begin
                    // Increment counters
                    counter <= counter + 1'b1;
                    if (w) begin
                        w_counter <= w_counter + 1'b1;
                    end
                end
            end
            default: begin
                state <= 2'b00;
            end
        endcase
    end
end

assign z = z_reg;

endmodule