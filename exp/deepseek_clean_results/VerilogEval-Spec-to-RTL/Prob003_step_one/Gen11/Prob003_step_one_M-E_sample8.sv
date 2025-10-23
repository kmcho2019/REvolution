module TopModule (
    output reg one
);
    // Single-state state machine implementation
    always @(*) begin
        one = 1'b1;
    end
endmodule