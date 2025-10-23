module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] counter;

    always_ff @(posedge clk) begin
        if (reset) begin
            counter <= 2'b11; // initialize counter to 3 (will decrement to 0 after 4 cycles)
        end else begin
            if (counter > 0) begin
                counter <= counter - 1'b1;
            end else begin
                counter <= 2'b00; // keep counter at 0 when not in reset
            end
        end
    end

    assign shift_ena = (counter > 0);

endmodule