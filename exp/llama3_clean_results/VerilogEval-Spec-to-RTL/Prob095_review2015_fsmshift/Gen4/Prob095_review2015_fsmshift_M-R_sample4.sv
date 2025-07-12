module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] count;

    always_ff @(posedge clk) begin
        if (reset) begin
            count <= 4 - 1; // Initialize count to 3 for 4 cycles
        end
        else if (count > 0) begin
            count <= count - 1; // Decrement count
        end
    end

    assign shift_ena = (count > 0) || reset; // Enable shift_ena if count is greater than 0 or reset is asserted

endmodule