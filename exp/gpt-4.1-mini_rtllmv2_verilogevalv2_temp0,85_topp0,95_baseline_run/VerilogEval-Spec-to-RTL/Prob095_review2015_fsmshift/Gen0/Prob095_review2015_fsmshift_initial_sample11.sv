module TopModule (
    input  wire clk,
    input  wire reset,
    output reg  shift_ena
);

    reg [2:0] count; // 3 bits to count from 4 down to 0

    always @(posedge clk) begin
        if (reset) begin
            count <= 3'd4;      // start count at 4 when reset asserted
            shift_ena <= 1'b1;  // enable shift for 4 cycles
        end else if (count != 0) begin
            count <= count - 1; // decrement count each clock
            shift_ena <= 1'b1;  // keep shift enabled while count > 0
        end else begin
            shift_ena <= 1'b0;  // disable shift after 4 cycles
        end
    end

endmodule