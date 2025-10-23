module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] counter;
    logic shift_enabled;

    always_ff @(posedge clk) begin
        if (reset) begin
            shift_enabled <= 1'b1;
            counter <= 0;
        end else if (shift_enabled && counter == 4) begin
            shift_enabled <= 1'b0;
        end else if (shift_enabled) begin
            counter <= counter + 1;
        end
    end

    assign shift_ena = shift_enabled;

endmodule