module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] count;
    logic reset_det;

    always_ff @(posedge clk) begin
        if (reset) begin
            count <= 4;
            reset_det <= 1'b1;
        end else if (reset_det && count > 0) begin
            count <= count - 1;
            if (count == 0) begin
                reset_det <= 1'b0;
            end
        end
    end

    assign shift_ena = (reset_det && count > 0);

endmodule