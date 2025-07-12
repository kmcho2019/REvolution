module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] count;
    logic [1:0] state;

    // Define states
    parameter IDLE = 2'b00;
    parameter RESET = 2'b01;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= RESET;
            count <= 3; // enable shift_ena for exactly 4 clock cycles
        end
        else if (state == RESET && count > 0) begin
            count <= count - 1'b1;
            if (count == 0) begin
                state <= IDLE;
            end
        end
    end

    assign shift_ena = (state == RESET && count > 0);

endmodule