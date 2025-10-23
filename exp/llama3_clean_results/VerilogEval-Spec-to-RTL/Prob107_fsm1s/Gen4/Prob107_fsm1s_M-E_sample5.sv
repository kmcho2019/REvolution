module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg counter; // 1-bit counter to keep track of the state

always @(*) begin
    out = counter; // Output is directly related to the counter value
end

always @(posedge clk) begin
    if(reset) begin // Synchronous reset
        counter <= 1'b1; // Reset to state B
    end else begin
        case(in)
            1'b0: counter <= ~counter; // Decrement on in=0
            1'b1: counter <= counter; // No change on in=1 (state B remains)
        endcase
    end
end

endmodule