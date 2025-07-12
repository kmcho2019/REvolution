module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    // Define the counter to track the number of clock cycles
    logic [1:0] counter;

    // Sequential logic to update the counter
    always_ff @(posedge clk) begin
        if (reset) begin
            counter <= 4;
        end else if (counter > 0) begin
            counter <= counter - 1;
        end
    end

    // Assert shift_ena when counter is greater than 0
    assign shift_ena = (counter > 0);

endmodule