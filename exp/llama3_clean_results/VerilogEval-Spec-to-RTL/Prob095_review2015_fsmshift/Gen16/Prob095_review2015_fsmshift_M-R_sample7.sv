module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] counter;

    always_ff @(posedge clk) begin
        if (reset) begin
            counter <= 0;
        end else if (counter < 4) begin
            counter <= counter + 1;
        end
    end

    assign shift_ena = (counter < 4) &&!reset;

endmodule