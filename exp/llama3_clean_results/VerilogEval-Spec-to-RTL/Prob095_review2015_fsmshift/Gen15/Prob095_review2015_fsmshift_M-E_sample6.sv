module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] reset_counter;

    // Initialize reset counter
    always_ff @(posedge clk) begin
        if (reset) begin
            reset_counter <= 0;
        end else begin
            if (reset_counter < 4) begin
                reset_counter <= reset_counter + 1;
            end
        end
    end

    // Assert shift_ena when reset counter is greater than 0 and less than or equal to 4
    assign shift_ena = (reset_counter > 0 && reset_counter <= 4);

endmodule