module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [1:0] cycle_counter;
    reg done;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            cycle_counter <= 2'b00;
            done <= 1'b0;
        end else if (!done) begin
            if (cycle_counter == 2'b11) begin
                done <= 1'b1;
            end else begin
                cycle_counter <= cycle_counter + 1;
            end
        end
    end

    // Combinational output logic
    assign shift_ena = !done;

endmodule