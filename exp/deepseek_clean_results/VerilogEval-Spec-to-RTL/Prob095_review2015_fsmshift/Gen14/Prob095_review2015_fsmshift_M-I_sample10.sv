module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [2:0] cycle_counter;
    reg done;

    assign shift_ena = (cycle_counter > 0) && !done;

    always @(posedge clk) begin
        if (reset) begin
            cycle_counter <= 3'b100;  // Count 4 cycles (4,3,2,1)
            done <= 1'b0;
        end else if (!done) begin
            if (cycle_counter > 0) begin
                cycle_counter <= cycle_counter - 1'b1;
            end else begin
                done <= 1'b1;
            end
        end
    end

endmodule