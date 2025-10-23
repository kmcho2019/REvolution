module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] count;
    logic       reset_flag;

    always_ff @(posedge clk) begin
        if (reset) begin
            count <= 0;
            reset_flag <= 1'b1;
        end else if (reset_flag && (count < 4)) begin
            count <= count + 1;
        end else if (reset_flag && (count == 4)) begin
            reset_flag <= 1'b0;
        end
    end

    assign shift_ena = reset_flag;

endmodule