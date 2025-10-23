module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] counter; // counter to keep track of the number of clock cycles

    always_ff @(posedge clk) begin
        if (reset) begin
            counter <= 2'b100; // initialize counter to 4
        end else if (counter > 0) begin
            counter <= counter - 1'b1; // decrement counter
        end
    end

    assign shift_ena = (counter > 0); // assert shift_ena as long as counter is greater than 0

endmodule