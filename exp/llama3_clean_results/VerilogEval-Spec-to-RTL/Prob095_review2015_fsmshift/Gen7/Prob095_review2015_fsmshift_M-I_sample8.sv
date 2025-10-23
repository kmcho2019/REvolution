module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] count;

    always_ff @(posedge clk) begin
        if (reset) begin
            count <= 4 - 1; // Set count to 3 to enable shift_ena for 4 cycles
        end
        else if (count != 0) begin
            count <= count - 1; // Decrement count
        end
    end

    assign shift_ena = (count != 0);

endmodule