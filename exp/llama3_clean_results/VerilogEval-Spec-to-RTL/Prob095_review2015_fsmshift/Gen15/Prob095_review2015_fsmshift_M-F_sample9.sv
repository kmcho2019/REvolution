module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] counter;

    always_ff @(posedge clk) begin
        if (reset) begin
            counter <= 2'b11; // Set counter to 3
        end else if (counter > 0) begin
            counter <= counter - 1; // Decrement counter
        end else begin
            counter <= 2'b00; // Counter stays at 0 once it reaches 0
        end
    end

    assign shift_ena = (counter > 0)? 1'b1 : 1'b0; // Assert shift_ena if counter > 0

endmodule