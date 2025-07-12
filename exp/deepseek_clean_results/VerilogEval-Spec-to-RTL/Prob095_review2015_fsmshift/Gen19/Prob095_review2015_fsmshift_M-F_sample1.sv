module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [1:0] counter;
    reg done;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 2'b11;  // Initialize to 3 (for 4 cycles)
            done <= 1'b0;
        end
        else if (!done) begin
            if (counter != 0)
                counter <= counter - 1;
            else
                done <= 1'b1;
        end
    end

    assign shift_ena = (counter != 0) && !done;

endmodule