module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [2:0] ena_count; // counter from 4 down to 0

    // Sequential logic: load 4 when reset is high, else decrement if > 0
    always @(posedge clk) begin
        if (reset) begin
            ena_count <= 3'd4;
        end else if (ena_count != 0) begin
            ena_count <= ena_count - 1;
        end
    end

    // Combinational assignment for shift_ena ensures no 1-cycle lag
    assign shift_ena = (ena_count != 0);

endmodule