module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] count;

    always_ff @(posedge clk) begin
        if (reset) begin
            count <= 0;
        end else if (count < 4) begin
            count <= count + 1;
        end
    end

    assign shift_ena = (count < 4) && !reset;

endmodule