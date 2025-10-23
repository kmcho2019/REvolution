module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] counter;

    always_ff @(posedge clk) begin
        if (reset) begin
            counter <= 4'b1000; // Initialize counter to 4 when reset is asserted
        end else if (counter > 0) begin
            counter <= counter - 1; // Decrement counter by 1 for each clock cycle
        end
    end

    assign shift_ena = (counter > 0); // Assert shift_ena as long as counter is greater than 0

endmodule