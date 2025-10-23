module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    // Counter to track cycles during reset
    logic [1:0] counter;

    // Sequential logic for counter and shift_ena
    always_ff @(posedge clk) begin
        if (reset) begin
            counter <= 2'b00; // Reset counter to 0
            shift_ena <= 1'b1; // Assert shift_ena on reset
        end else begin
            if (counter < 4) begin
                counter <= counter + 1'b1; // Increment counter if less than 4
                shift_ena <= 1'b1; // Keep shift_ena high if counter less than 4
            end else begin
                shift_ena <= 1'b0; // Deassert shift_ena if counter is 4 or more
            end
        end
    end

endmodule