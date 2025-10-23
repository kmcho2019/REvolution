module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] counter = 0;
    logic shift_ena_next;

    assign shift_ena_next = (counter < 4) && (reset || shift_ena);

    always_ff @(posedge clk) begin
        if (reset) begin
            shift_ena <= 1'b1;
            counter <= 1'b1;
        end else if (shift_ena) begin
            shift_ena <= shift_ena_next;
            counter <= counter + 1;
        end else begin
            shift_ena <= shift_ena_next;
            counter <= 2'b00;
        end
    end

endmodule