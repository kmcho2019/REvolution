module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [1:0] counter;  // 2-bit counter for 0-3
    reg done;

    assign shift_ena = !done;  // Active until done is set

    always @(posedge clk) begin
        if (reset) begin
            counter <= 0;
            done <= 0;
        end else if (!done) begin
            if (counter == 2'b11) begin  // After 4 cycles (0,1,2,3)
                done <= 1;
            end else begin
                counter <= counter + 1;
            end
        end
    end

endmodule