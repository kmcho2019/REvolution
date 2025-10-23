module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [1:0] cycle_counter;

    // Sequential counter logic
    always @(posedge clk) begin
        if (reset) begin
            cycle_counter <= 2'b00;
        end else if (cycle_counter != 2'b11) begin
            cycle_counter <= cycle_counter + 1;
        end
    end

    // Combinational output logic
    assign shift_ena = (cycle_counter != 2'b11);

endmodule