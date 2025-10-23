module TopModule (
    input  clk,
    input  reset,
    output reg shift_ena
);

    reg [2:0] counter;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 3'd4;      // Load 4 cycles on reset
        end else if (counter != 3'd0) begin
            counter <= counter - 3'd1;
        end
        // else counter remains zero
    end

    // shift_ena asserted while counter nonzero
    always @(posedge clk) begin
        shift_ena <= (counter != 3'd0);
    end

endmodule