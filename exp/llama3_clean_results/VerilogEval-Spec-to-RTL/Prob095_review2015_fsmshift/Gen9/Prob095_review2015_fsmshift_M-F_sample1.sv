module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] count; // Counter to count up to 4
    logic counting; // Flag to indicate if we are in the counting phase

    always_ff @(posedge clk) begin
        if (reset) begin
            count <= 0;
            counting <= 1'b1; // Start counting when reset
        end else if (count < 4 && counting) begin
            count <= count + 1; // Increment counter if we are counting
        end else if (count == 4 && counting) begin
            counting <= 1'b0; // Stop counting when counter reaches 4
        end
    end

    assign shift_ena = counting && (count < 4); // Assert shift_ena while counting and counter is less than 4

endmodule