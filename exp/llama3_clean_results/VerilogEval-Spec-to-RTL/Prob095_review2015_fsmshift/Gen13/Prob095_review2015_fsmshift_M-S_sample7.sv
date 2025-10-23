module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    reg [1:0] counter = 0;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 4;
        end else if (counter > 0) begin
            counter <= counter - 1;
        end
    end

    assign shift_ena = (counter > 0);

endmodule