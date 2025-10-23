module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] count;
    logic in_reset_state;

    always_ff @(posedge clk) begin
        if (reset) begin
            count <= 3; // enable shift_ena for exactly 4 clock cycles
            in_reset_state <= 1'b1;
        end
        else if (in_reset_state && count > 0) begin
            count <= count - 1'b1;
            if (count == 0) begin
                in_reset_state <= 1'b0;
            end
        end
    end

    always_comb begin
        shift_ena = (in_reset_state && count > 0) || (count > 0 &&!in_reset_state);
    end

endmodule