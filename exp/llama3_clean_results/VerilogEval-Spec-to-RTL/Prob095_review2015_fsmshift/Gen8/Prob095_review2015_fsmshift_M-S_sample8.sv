module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] counter; // 2-bit counter

    always_ff @(posedge clk) begin
        if (reset) begin
            counter <= 2'd3; // Initialize counter to 3 on reset
        end else if (counter > 0) begin
            counter <= counter - 1; // Decrement counter
        end else begin
            counter <= 2'd0; // Keep counter at 0 once it reaches 0
        end
    end

    assign shift_ena = (counter > 0); // Drive shift_ena based on counter value

endmodule