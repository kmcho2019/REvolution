module TopModule (
    output reg one
);
    // Single-state state machine
    always @(*) begin
        one = 1'b1;  // The only state always outputs 1
    end
endmodule