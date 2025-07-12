module TopModule (
    input  wire clk,
    input  wire reset,      // synchronous active-high reset
    output reg  shift_ena
);

    reg [2:0] counter;  // counts down from 4 to 0

    always @(posedge clk) begin
        if (reset) begin
            counter   <= 3'd4;
            shift_ena <= 1'b1;
        end else begin
            if (counter != 3'd0) begin
                counter   <= counter - 1'b1;
                shift_ena <= 1'b1;
            end else begin
                shift_ena <= 1'b0;
            end
        end
    end

endmodule