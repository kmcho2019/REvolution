module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] state; // 0: idle, 1: enable, 2-3: countdown

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= 3; // Set state to enable for 4 cycles
        end
        else if (state == 3) begin
            state <= 2; // Decrement state
        end
        else if (state > 0) begin
            state <= state - 1; // Decrement state
        end
        else begin
            state <= 0; // Keep state at idle
        end
    end

    assign shift_ena = (state > 0)? 1'b1 : 1'b0;

endmodule