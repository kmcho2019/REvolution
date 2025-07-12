module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [1:0] cycle_counter;

    assign shift_ena = (cycle_counter != 2'b00);

    always @(posedge clk) begin
        if (reset) begin
            cycle_counter <= 2'b11;  // Initialize to 3 (4 cycles: 3,2,1,0)
        end else if (cycle_counter != 2'b00) begin
            cycle_counter <= cycle_counter - 1'b1;
        end
    end

endmodule