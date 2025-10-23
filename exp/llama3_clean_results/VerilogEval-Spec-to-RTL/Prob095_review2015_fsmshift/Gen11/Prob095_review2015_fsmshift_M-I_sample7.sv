module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] counter;

    always_ff @(posedge clk) begin
        if (reset) begin
            counter <= 2'b00;
            shift_ena <= 1'b1;
        end
        else if (counter < 4) begin
            counter <= counter + 1;
            shift_ena <= (counter >= 1 && counter <= 4) ? 1'b1 : 1'b0;
        end
        else begin
            counter <= 4'b1111; // set counter to max value to prevent increment
            shift_ena <= 1'b0;
        end
    end

endmodule