module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [2:0] counter;
    reg done;

    assign shift_ena = !done && (counter <= 3);

    always @(posedge clk) begin
        if (reset) begin
            counter <= 0;
            done <= 0;
        end else if (!done) begin
            if (counter == 3) begin
                done <= 1;
            end else begin
                counter <= counter + 1;
            end
        end
    end

endmodule