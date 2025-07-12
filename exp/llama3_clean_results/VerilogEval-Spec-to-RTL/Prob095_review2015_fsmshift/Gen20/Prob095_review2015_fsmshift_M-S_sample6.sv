module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] count;

    always_ff @(posedge clk) begin
        if (reset) begin
            count <= 3; // enable shift_ena for 4 cycles after reset
        end else if (count > 0) begin
            count <= count - 1; // decrement count
        end
    end

    assign shift_ena = (count > 0); // assert shift_ena when count is greater than 0

endmodule