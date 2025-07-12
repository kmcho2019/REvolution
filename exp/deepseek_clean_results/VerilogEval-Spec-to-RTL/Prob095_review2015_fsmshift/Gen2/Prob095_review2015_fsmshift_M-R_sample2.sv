module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [1:0] counter;

    // shift_ena is high when counter is not zero
    assign shift_ena = (counter != 2'b00);

    always @(posedge clk) begin
        if (reset) begin
            counter <= 2'b11;  // Load 3 for 4 cycles (3,2,1,0)
        end else if (counter != 2'b00) begin
            counter <= counter - 1;
        end
        // When counter reaches 0, it stays 0 until next reset
    end

endmodule