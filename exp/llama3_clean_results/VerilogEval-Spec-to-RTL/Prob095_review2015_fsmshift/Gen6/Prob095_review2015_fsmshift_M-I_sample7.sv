module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] counter; // 2-bit unsigned integer counter

    always_ff @(posedge clk) begin
        if (reset) begin
            counter <= 2'd4; // initialize counter to 4
        end else if (counter > 0) begin
            counter <= counter - 1; // decrement counter
        end else begin
            counter <= 0; // keep counter at 0 when it reaches 0
        end
    end

    assign shift_ena = (counter > 0); // assert shift_ena as long as counter is greater than 0

endmodule