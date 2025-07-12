module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] state; // 2-bit state variable
    logic [1:0] counter; // 2-bit counter

    // Define the states
    localparam RESET_STATE = 2'b00;
    localparam ENABLE_STATE = 2'b01;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= RESET_STATE; // Transition to RESET_STATE
            counter <= 2'b11; // Initialize counter to 3 (which is equivalent to 4 - 1)
            shift_ena <= 1'b1; // Assert shift_ena
        end else if (state == RESET_STATE) begin
            if (counter > 0) begin
                counter <= counter - 1; // Decrement counter
            end else begin
                state <= ENABLE_STATE; // Transition to ENABLE_STATE
                shift_ena <= 1'b0; // Deassert shift_ena
            end
        end else begin
            // Stay in ENABLE_STATE
            shift_ena <= 1'b0;
        end
    end

endmodule