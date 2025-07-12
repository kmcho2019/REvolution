module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] count;
    logic shift;

    always_ff @(posedge clk) begin
        if (reset) begin
            count <= 4; // Set count to 4 to enable shift_ena for 4 cycles
            shift <= 1'b1; // Set shift to 1
        end
        else if (shift && count > 0) begin
            count <= count - 1; // Decrement count
            if (count == 1) begin
                shift <= 1'b0; // Set shift to 0 when count reaches 0
            end
        end
    end

    assign shift_ena = shift;

endmodule