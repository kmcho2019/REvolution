module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] count;

    always_ff @(posedge clk) begin
        if (reset) begin
            count <= 4;
            shift_ena <= 1'b1;
        end
        else if (count > 0) begin
            count <= count - 1;
            shift_ena <= 1'b1;
        end
        else begin
            shift_ena <= 1'b0;
        end
    end

endmodule