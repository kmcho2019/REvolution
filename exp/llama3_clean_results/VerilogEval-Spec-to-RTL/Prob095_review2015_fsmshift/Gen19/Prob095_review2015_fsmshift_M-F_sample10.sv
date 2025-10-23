module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] count = 2'b00; // Initialize count to 0 to prevent undefined behavior

    always_ff @(posedge clk) begin
        if (reset) begin
            count <= 4 - 1; // Initialize count to 3 when reset is asserted
        end else if (count > 0) begin
            count <= count - 1; // Decrement count at each clock cycle
        end else begin
            count <= 0; // Ensure count remains 0 once it reaches 0
        end
    end

    assign shift_ena = (count > 0); // Assert shift_ena as long as count is greater than 0

endmodule