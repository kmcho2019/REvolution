module TopModule (
    input  wire clk,
    input  wire reset,      // synchronous active-high reset
    output reg  shift_ena
);

    reg [2:0] counter;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 3'd4;       // Load counter on reset
        end else if (counter != 0) begin
            counter <= counter - 1;
        end
    end

    always @(posedge clk) begin
        shift_ena <= (counter != 0);
    end

endmodule