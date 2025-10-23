module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [3:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 4'b0001;  // Start with first cycle active
        end else if (state != 4'b1000) begin
            state <= {state[2:0], 1'b0};  // Rotate left until we reach last state
        end
    end

    assign shift_ena = |state;  // OR of all bits - high during any active cycle

endmodule