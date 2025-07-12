module TopModule (
    input  wire clk,
    input  wire reset,      // synchronous active-high reset
    output wire shift_ena
);

    reg [2:0] counter; // 3 bits to count from 4 down to 0

    always @(posedge clk) begin
        if (reset) begin
            counter <= 3'd4;    // Load 4 on reset to enable shift_ena for 4 cycles
        end else if (counter != 3'd0) begin
            counter <= counter - 1;
        end
        // else counter stays at 0, shift_ena deasserted indefinitely
    end

    assign shift_ena = (counter != 3'd0);

endmodule