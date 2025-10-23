module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] count;

    always_ff @(posedge clk) begin
        if (reset) begin
            count <= 2'd3;
        end
        else if (count > 0) begin
            count <= count - 1'b1;
        end
    end

    assign shift_ena = (count > 0) ? 1'b1 : 1'b0;

endmodule