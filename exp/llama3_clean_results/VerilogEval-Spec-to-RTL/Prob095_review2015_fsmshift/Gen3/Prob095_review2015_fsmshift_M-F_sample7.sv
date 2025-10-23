module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] counter; // counter to keep track of the number of clock cycles

    always_ff @(posedge clk) begin
        if (reset) begin
            // Initialize counter to 3 when reset is asserted
            counter <= 2'd3;
            // Assert shift_ena when reset is asserted
            shift_ena <= 1'b1;
        end else begin
            if (counter > 0) begin
                // Decrement counter when it's greater than 0
                counter <= counter - 1'b1;
                // Assert shift_ena when counter is greater than 0
                shift_ena <= 1'b1;
            end else begin
                // De-assert shift_ena when counter is 0
                shift_ena <= 1'b0;
            end
        end
    end

endmodule