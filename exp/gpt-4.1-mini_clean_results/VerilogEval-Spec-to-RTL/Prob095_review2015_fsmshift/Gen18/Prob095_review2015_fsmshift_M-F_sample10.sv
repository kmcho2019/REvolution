module TopModule (
    input  wire clk,
    input  wire reset,      // synchronous active-high reset
    output reg  shift_ena
);

    reg [2:0] counter;  // counts number of asserted cycles (0 to 4)

    always @(posedge clk) begin
        if (reset) begin
            counter   <= 3'd0;
            shift_ena <= 1'b1;
        end else if (shift_ena) begin
            if (counter < 3'd3) begin
                counter   <= counter + 1'b1;
                shift_ena <= 1'b1;
            end else begin
                // After 4 cycles asserted (count 0..3), disable shift_ena
                shift_ena <= 1'b0;
            end
        end else begin
            shift_ena <= 1'b0;
        end
    end

endmodule