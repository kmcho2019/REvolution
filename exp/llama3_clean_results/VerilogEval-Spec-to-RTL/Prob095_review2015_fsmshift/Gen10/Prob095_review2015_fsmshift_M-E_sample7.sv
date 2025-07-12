module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] counter;

    always_ff @(posedge clk) begin
        if (reset) begin
            counter <= 4;
        end else if (counter > 0) begin
            counter <= counter - 1;
        end
    end

    always_comb begin
        if (counter > 0) begin
            shift_ena = 1'b1;
        end else begin
            shift_ena = 1'b0;
        end
    end

endmodule