module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] counter; // 2-bit counter

    always_ff @(posedge clk) begin
        if (reset) begin
            counter <= 2'd3; // initialize counter to 3
        end else if (counter > 0) begin
            counter <= counter - 1; // decrement counter
        end
    end

    assign shift_ena = (counter > 0); // assert shift_ena as long as counter is greater than 0

endmodule