module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] state;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= 2'd3; // enable shift_ena for exactly 4 clock cycles
        end
        else if (state > 0) begin
            state <= state - 1'b1;
        end
        else begin
            state <= 0;
        end
    end

    always_comb begin
        shift_ena = (state > 0);
    end

endmodule