module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] state; // 0: IDLE, 1: SHIFTING
    logic [1:0] counter;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= 1'b1; // Transition to SHIFTING state on reset
            counter <= 2'b00; // Initialize counter to 0
        end else if (state == 1'b1) begin // In SHIFTING state
            if (counter == 2'b11) begin // Counter has reached 4
                state <= 1'b0; // Transition back to IDLE state
                counter <= 2'b00; // Reset counter
            end else begin
                counter <= counter + 1; // Increment counter
            end
        end
    end

    assign shift_ena = (state == 1'b1); // Assert shift_ena when in SHIFTING state

endmodule