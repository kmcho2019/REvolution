module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [1:0] counter;
    reg done;

    // shift_ena is active when counting (not done)
    assign shift_ena = ~done;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 2'b00;
            done <= 1'b0;
        end else if (~done) begin
            if (counter == 2'b11) begin
                done <= 1'b1;  // Mark completion after 4 cycles
            end else begin
                counter <= counter + 1;  // Increment counter
            end
        end
    end

endmodule