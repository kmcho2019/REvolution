module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] count = 0; // Initialize count to 0

    always_ff @(posedge clk) begin
        if (reset) begin
            count <= 3; // Set count to 3 when reset is asserted
        end else if (count > 0) begin
            count <= count - 1;
        end
    end

    assign shift_ena = (count > 0);

endmodule