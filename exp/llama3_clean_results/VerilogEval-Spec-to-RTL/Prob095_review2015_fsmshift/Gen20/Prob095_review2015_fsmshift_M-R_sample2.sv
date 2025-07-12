module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    enum logic [1:0] {IDLE, ENABLE} state;
    logic [1:0] counter; // 2-bit counter

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            counter <= 2'b00; // Initialize counter to 0
        end else if (state == IDLE) begin
            state <= ENABLE;
            counter <= 2'b00; // Initialize counter to 0
        end else if (state == ENABLE) begin
            counter <= counter + 1; // Increment counter
            if (counter == 4'b11) begin // Check if counter has reached 3
                state <= IDLE;
            end
        end
    end

    assign shift_ena = (state == ENABLE);

endmodule