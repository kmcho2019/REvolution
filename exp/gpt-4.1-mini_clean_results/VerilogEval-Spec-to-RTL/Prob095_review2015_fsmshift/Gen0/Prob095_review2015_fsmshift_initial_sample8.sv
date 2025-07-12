module TopModule (
    input clk,
    input reset,
    output reg shift_ena
);

    reg [1:0] count;

    always @(posedge clk) begin
        if (reset) begin
            // On synchronous reset, start the 4 cycle shift_ena assertion
            shift_ena <= 1'b1;
            count <= 2'b00;
        end else if (shift_ena) begin
            if (count == 2'd3) begin
                // After 4 cycles (count from 0 to 3), disable shift_ena
                shift_ena <= 1'b0;
            end
            count <= count + 1'b1;
        end
    end

endmodule