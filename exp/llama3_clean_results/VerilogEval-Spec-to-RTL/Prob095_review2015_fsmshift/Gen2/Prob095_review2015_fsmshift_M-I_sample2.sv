module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] counter; // counter to keep track of the number of clock cycles

    always_ff @(posedge clk) begin
        if (reset) begin
            counter <= 4'd4;
            shift_ena <= 1'b1;
        end else if (counter > 0) begin
            counter <= counter - 1'b1;
            shift_ena <= 1'b1;
        end else begin
            counter <= counter;
            shift_ena <= 1'b0;
        end
    end

endmodule