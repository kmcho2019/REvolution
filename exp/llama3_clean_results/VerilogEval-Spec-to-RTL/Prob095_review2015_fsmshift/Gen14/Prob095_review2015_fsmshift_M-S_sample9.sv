module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] counter = 0; // Initialize counter to 0

    always_ff @(posedge clk) begin
        if (reset) begin
            counter <= 3; // Reset counter to 3
        end else if (counter > 0) begin
            counter <= counter - 1; // Decrement counter
        end
    end

    assign shift_ena = (counter > 0); // Assert shift_ena if counter > 0

endmodule