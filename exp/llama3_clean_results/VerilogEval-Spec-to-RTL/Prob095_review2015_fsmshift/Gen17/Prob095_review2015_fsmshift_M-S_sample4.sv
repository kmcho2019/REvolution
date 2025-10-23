module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] counter = 2'd0; // Initialize counter to 0

    always_ff @(posedge clk) begin
        if (reset) begin
            counter <= 2'd3; // Initialize counter to 3 on reset
        end else if (counter > 0) begin
            counter <= counter - 1; // Decrement counter
        end
    end

    assign shift_ena = (counter > 0); // Assign shift_ena based on counter

endmodule