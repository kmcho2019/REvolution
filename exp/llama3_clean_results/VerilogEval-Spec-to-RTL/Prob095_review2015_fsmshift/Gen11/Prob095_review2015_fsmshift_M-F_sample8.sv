module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [2:0] counter; // Widened the counter to 3 bits

    always_ff @(posedge clk) begin
        if (reset) begin
            counter <= 4; // Now, counter can be initialized to 4
        end else if (counter > 0) begin
            counter <= counter - 1;
        end else begin
            counter <= 0; // Ensure counter stays at 0 once it reaches 0
        end
    end

    assign shift_ena = (counter > 0); // Assert shift_ena as long as counter is greater than 0

endmodule