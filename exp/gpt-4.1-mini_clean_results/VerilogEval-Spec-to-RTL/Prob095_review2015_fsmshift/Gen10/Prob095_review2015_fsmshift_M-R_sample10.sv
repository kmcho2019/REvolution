module TopModule (
    input  wire clk,
    input  wire reset,    // synchronous active high reset
    output reg  shift_ena
);

    reg [2:0] counter;

    always @(posedge clk) begin
        if (reset) begin
            counter   <= 3'd4;
            shift_ena <= 1'b1;
        end else if (counter != 0) begin
            counter   <= counter - 3'd1;
            shift_ena <= 1'b1;
        end else begin
            // counter == 0, shift_ena deasserted forever until next reset
            shift_ena <= 1'b0;
        end
    end

endmodule