module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [1:0] counter;

    assign shift_ena = (counter < 2'd4);  // True for 0,1,2,3 (4 cycles)

    always @(posedge clk) begin
        if (reset) begin
            counter <= 2'd0;
        end else if (counter < 2'd3) begin  // Stop counting after reaching 3
            counter <= counter + 1;
        end
    end

endmodule