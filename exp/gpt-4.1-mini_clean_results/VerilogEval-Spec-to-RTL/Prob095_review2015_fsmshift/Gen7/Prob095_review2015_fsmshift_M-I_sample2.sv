module TopModule (
    input  wire clk,
    input  wire reset,      // synchronous active-high reset
    output wire shift_ena
);

    reg [2:0] cycle_count;  // enough to count up to 4

    always @(posedge clk) begin
        if (reset) begin
            cycle_count <= 3'd0;    // start counting at 0 on reset cycle
        end else if (cycle_count < 3'd4) begin
            cycle_count <= cycle_count + 1'b1;  // count up to 4 cycles
        end
        // else stay at 4 (saturate)
    end

    // shift_ena is high for cycles 0,1,2,3 (4 cycles)
    assign shift_ena = (cycle_count < 3'd4);

endmodule