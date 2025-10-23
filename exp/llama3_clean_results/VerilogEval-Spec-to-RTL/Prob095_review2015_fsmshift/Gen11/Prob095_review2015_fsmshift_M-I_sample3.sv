module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] counter;

    always_ff @(posedge clk) begin
        if (reset) begin
            counter <= 2'd4; // Initialize to 4 to assert shift_ena for 4 cycles
        end else if (counter > 0) begin
            counter <= counter - 1;
        end else begin
            counter <= 0; // Keep counter at 0 once it reaches 0
        end
    end

    assign shift_ena = (counter > 0);

endmodule