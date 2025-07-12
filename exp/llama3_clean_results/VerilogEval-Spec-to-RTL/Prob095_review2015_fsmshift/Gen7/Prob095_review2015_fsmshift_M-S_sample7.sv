module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] counter;

    always_ff @(posedge clk) begin
        if (reset) begin
            counter <= 4 - 1; // Enable for 4 cycles starting from the next clock edge
        end
        else if (counter > 0) begin
            counter <= counter - 1;
        end
    end

    assign shift_ena = (counter > 0);

endmodule