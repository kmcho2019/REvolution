module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] count = 0;

    always_ff @(posedge clk) begin
        if (reset) begin
            count <= 4 - 1; // Set count to 3 when reset is asserted
        end else if (count > 0) begin
            count <= count - 1;
        end
    end

    assign shift_ena = (count > 0 || reset);

endmodule