module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [2:0] cycle_counter;  // 3-bit counter to count 4 cycles (values 4 down to 1)

    assign shift_ena = (cycle_counter != 3'b000);

    always @(posedge clk) begin
        if (reset) begin
            cycle_counter <= 3'b100;  // Initialize to 4 (counts 4,3,2,1)
        end else if (cycle_counter != 3'b000) begin
            cycle_counter <= cycle_counter - 1'b1;
        end
    end

endmodule