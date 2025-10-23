module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] counter; // A 2-bit counter can represent 0 to 3, which is sufficient for our needs

    always_ff @(posedge clk) begin
        if (reset) begin
            counter <= 3; // Initialize counter to 3, which will decrement to 0 over 4 cycles
        end else if (counter > 0) begin
            counter <= counter - 1; // Decrement counter until it reaches 0
        end
    end

    assign shift_ena = (counter > 0); // Assert shift_ena as long as counter is greater than 0

endmodule