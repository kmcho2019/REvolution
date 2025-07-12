module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire pattern_detected,
    output wire shift_ena
);

    reg [2:0] counter;

    always @(posedge clk) begin
        if (reset) begin
            // On synchronous reset, enable shift for 4 cycles
            counter <= 3'd4;
        end else if (pattern_detected) begin
            // On pattern detected, reload counter to 4 cycles
            counter <= 3'd4;
        end else if (counter != 3'd0) begin
            // Decrement counter when active
            counter <= counter - 1;
        end
    end

    assign shift_ena = (counter != 3'd0);

endmodule