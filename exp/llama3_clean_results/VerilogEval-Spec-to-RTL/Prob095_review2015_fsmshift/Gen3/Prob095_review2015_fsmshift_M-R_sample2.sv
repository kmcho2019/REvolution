module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] counter; // counter to keep track of the number of clock cycles

    always_ff @(posedge clk) begin
        if (reset) begin
            counter <= 2'd3; // Initialize counter to 3
        end else if (counter > 0) begin
            counter <= counter - 1'b1; // Decrement counter
        end
    end

    assign shift_ena = (counter > 0) || reset; // Assign shift_ena based on counter and reset

endmodule