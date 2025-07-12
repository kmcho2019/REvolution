module TopModule (
    output reg one
);
    // Single-state FSM implementation
    always @(*) begin
        one = 1'b1;
    end
endmodule