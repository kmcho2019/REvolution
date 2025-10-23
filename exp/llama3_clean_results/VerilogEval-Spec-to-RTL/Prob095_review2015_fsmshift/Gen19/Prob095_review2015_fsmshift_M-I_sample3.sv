module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] counter; // 2-bit counter

    always_ff @(posedge clk) begin
        if (reset) begin
            counter <= 2'b00; // Initialize counter to 0
            shift_ena <= 1'b1; // Assert shift_ena
        end else if (counter < 4) begin
            counter <= counter + 1; // Increment counter
            shift_ena <= 1'b1; // Assert shift_ena
        end else begin
            shift_ena <= 1'b0; // Deassert shift_ena
        end
    end

endmodule