module TopModule (
    input clk,
    input reset,
    output reg shift_ena
);

    reg [2:0] shift_count;

    always @(posedge clk) begin
        if (reset) begin
            shift_count <= 3'd4;  // Enable for 4 cycles after reset
        end else if (shift_count != 0) begin
            shift_count <= shift_count - 1'b1;
        end
    end

    // shift_ena asserted while shift_count is non-zero
    always @(posedge clk) begin
        shift_ena <= (shift_count != 0);
    end

endmodule