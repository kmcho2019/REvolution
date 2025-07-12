module TopModule (
    input  wire clk,
    input  wire reset,    // synchronous active-high reset
    output reg  shift_ena
);

    reg [2:0] cnt; // 3-bit counter for counting 4 cycles

    always @(posedge clk) begin
        if (reset) begin
            cnt <= 3'd4;      // start counting 4 cycles
            shift_ena <= 1'b1;
        end else if (cnt != 3'd0) begin
            cnt <= cnt - 1;
            shift_ena <= 1'b1;
        end else begin
            shift_ena <= 1'b0;
        end
    end

endmodule