module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] state; // 2-bit state register

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= 2'b11; // Transition to SHIFT state with counter = 3
        end else if (state == 2'b11) begin
            state <= 2'b10; // Decrement counter
        end else if (state == 2'b10) begin
            state <= 2'b01; // Decrement counter
        end else if (state == 2'b01) begin
            state <= 2'b00; // Decrement counter and transition to IDLE
        end
    end

    assign shift_ena = (state == 2'b11) || (state == 2'b10) || (state == 2'b01);

endmodule