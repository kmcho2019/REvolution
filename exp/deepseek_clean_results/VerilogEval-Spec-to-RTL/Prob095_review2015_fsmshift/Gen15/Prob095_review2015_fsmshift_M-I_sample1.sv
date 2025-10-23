module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [1:0] cycle_counter;  // 2-bit counter sufficient for counting 4 cycles (3 down to 0)

    assign shift_ena = (cycle_counter != 2'b00);

    always @(posedge clk) begin
        if (reset) begin
            cycle_counter <= 2'b11;  // Initialize to 3 (counts 3,2,1,0)
        end else if (cycle_counter != 2'b00) begin
            cycle_counter <= cycle_counter - 1'b1;
        end
    end

endmodule