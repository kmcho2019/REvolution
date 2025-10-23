module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [1:0] counter;
    reg done;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 2'b00;
            done <= 1'b0;
        end else if (!done) begin
            if (counter == 2'b11)
                done <= 1'b1;
            else
                counter <= counter + 1;
        end
    end

    assign shift_ena = !done;

endmodule