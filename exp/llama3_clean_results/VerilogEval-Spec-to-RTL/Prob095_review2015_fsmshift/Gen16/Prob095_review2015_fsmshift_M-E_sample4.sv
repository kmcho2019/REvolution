module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] counter = 4; // Initialize counter to 4
    logic ena_state = 1'b0; // State to track shift enable

    always_ff @(posedge clk) begin
        if (reset) begin
            counter <= 4;
            ena_state <= 1'b1; // Set shift_ena high on reset
        end else begin
            if (ena_state) begin
                if (counter > 0) begin
                    counter <= counter - 1;
                end else begin
                    ena_state <= 1'b0; // Clear shift_ena when counter reaches 0
                end
            end
        end
    end

    assign shift_ena = ena_state; // Assign shift_ena from the state

endmodule