module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    localparam COUNTER_WIDTH = 2;
    localparam CYCLES_TO_ENABLE = 3; // Adjusted to enable shift_ena for 4 cycles

    logic [COUNTER_WIDTH-1:0] counter;

    always_ff @(posedge clk) begin
        if (reset) begin
            counter <= CYCLES_TO_ENABLE; // Initialize counter for 4 cycles
        end else if (counter > 0) begin
            counter <= counter - 1'b1; // Decrement counter
        end
    end

    assign shift_ena = (counter > 0); // Directly drive shift_ena based on counter value

endmodule