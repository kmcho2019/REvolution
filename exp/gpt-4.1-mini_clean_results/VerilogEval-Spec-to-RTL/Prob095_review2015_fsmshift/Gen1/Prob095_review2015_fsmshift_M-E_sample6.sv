module TopModule (
    input clk,
    input reset,
    output reg shift_ena
);

    reg [2:0] counter; // enough bits to count from 4 down to 0

    always @(posedge clk) begin
        if (reset) begin
            counter <= 3'd4;   // load 4 on synchronous reset
        end else if (counter != 0) begin
            counter <= counter - 1;
        end
    end

    always @(posedge clk) begin
        shift_ena <= (counter != 0);
    end

endmodule