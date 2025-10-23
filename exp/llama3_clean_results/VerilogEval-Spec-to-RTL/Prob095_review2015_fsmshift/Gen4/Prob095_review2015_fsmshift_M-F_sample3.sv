module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] count;

    always_ff @(posedge clk) begin
        if (reset) begin
            count <= 4; // enable shift_ena for exactly 4 clock cycles
        end
        else if (count > 0) begin
            count <= count - 1'b1;
        end
        else begin
            count <= 0;
        end
    end

    assign shift_ena = (count > 0 && count <= 4);

endmodule