module TopModule (
    input  wire clk,
    input  wire reset,      // synchronous active-high reset
    output wire shift_ena
);

    reg [2:0] counter;

    // Synchronous process: counter reload on reset, otherwise count down if not zero
    always @(posedge clk) begin
        if (reset) begin
            counter <= 3'd4;   // Load counter with 4 on reset
        end else if (counter != 0) begin
            counter <= counter - 1;
        end
    end

    // shift_ena asserted as long as counter is not zero
    assign shift_ena = (counter != 0);

endmodule