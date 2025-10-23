module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] count;

    always_ff @(posedge clk) begin
        if (reset) begin
            count <= 3; // enable shift_ena for exactly 4 clock cycles
        end
        else if (count > 0) begin
            count <= count - 1'b1;
        end
    end

    always_comb begin
        shift_ena = (count > 0);
    end

endmodule