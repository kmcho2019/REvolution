module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] counter;

    always_ff @(posedge clk) begin
        if (reset) begin
            counter <= 2'b11; // Set counter to 3 (to enable shift_ena for 4 cycles)
            shift_ena <= 1'b1;
        end else if (counter > 0) begin
            counter <= counter - 1'b1;
            shift_ena <= 1'b1;
        end else begin
            shift_ena <= 1'b0;
        end
    end

endmodule