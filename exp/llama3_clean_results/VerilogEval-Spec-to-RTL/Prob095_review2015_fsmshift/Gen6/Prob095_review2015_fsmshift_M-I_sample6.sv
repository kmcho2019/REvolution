module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic reset_status;
    logic [1:0] count;

    always_ff @(posedge clk) begin
        if (reset) begin
            reset_status <= 1'b1;
            count <= 2'd3;
        end
        else if (reset_status && (count > 0)) begin
            count <= count - 1'b1;
            if (count == 0) begin
                reset_status <= 1'b0;
            end
        end
    end

    assign shift_ena = (reset_status && (count > 0)) ? 1'b1 : 1'b0;

endmodule