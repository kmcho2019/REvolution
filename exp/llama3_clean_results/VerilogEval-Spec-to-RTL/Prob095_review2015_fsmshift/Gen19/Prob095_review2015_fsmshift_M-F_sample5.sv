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
            counter <= 2'b00; // Reset counter to 0 when reset is high
        end else if (counter < 4) begin
            counter <= counter + 1'b1; // Increment counter if less than 4
        end else begin
            counter <= 4'b0000; // Reset counter after reaching 4
        end
    end

    // Combinational logic for shift_ena
    always_comb begin
        shift_ena = (counter < 4)? 1'b1 : 1'b0; // Assert shift_ena when counter < 4
    end

endmodule