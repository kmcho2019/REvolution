module TopModule (
    input clk,
    input reset,
    output reg shift_ena
);

    reg [1:0] counter;
    reg done;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 2'b00;
            done <= 1'b0;
            shift_ena <= 1'b1;  // Assert immediately on reset
        end else if (~done) begin
            if (counter == 2'b11) begin
                done <= 1'b1;
                shift_ena <= 1'b0;  // Deassert after 4th cycle
            end else begin
                counter <= counter + 1;
                shift_ena <= 1'b1;  // Keep asserted during count
            end
        end else begin
            shift_ena <= 1'b0;  // Maintain deasserted
        end
    end

endmodule