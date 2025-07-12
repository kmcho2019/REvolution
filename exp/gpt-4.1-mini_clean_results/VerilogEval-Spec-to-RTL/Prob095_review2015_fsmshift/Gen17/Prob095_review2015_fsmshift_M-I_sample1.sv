module TopModule (
    input  wire clk,
    input  wire reset,      // synchronous active-high reset
    output reg  shift_ena
);

    reg [2:0] counter;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 3'd4;
        end else if (counter != 3'd0) begin
            counter <= counter - 1;
        end else begin
            counter <= 3'd0;
        end

        // shift_ena is asserted while counter is non-zero
        shift_ena <= (counter != 3'd0);
    end

endmodule