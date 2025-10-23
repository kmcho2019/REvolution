module TopModule (
    input  wire clk,
    input  wire reset,    // synchronous active high reset
    output reg  shift_ena
);

    reg [1:0] counter; // 2 bits are enough to count down from 3

    always @(posedge clk) begin
        if (reset) begin
            counter   <= 2'd3;  // count remaining cycles after current
            shift_ena <= 1'b1;  // assert immediately on reset cycle
        end else if (counter != 0) begin
            counter   <= counter - 2'd1;
            shift_ena <= 1'b1;
        end else begin
            shift_ena <= 1'b0;
        end
    end

endmodule