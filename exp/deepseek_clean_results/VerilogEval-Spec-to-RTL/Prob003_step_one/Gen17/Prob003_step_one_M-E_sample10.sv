module TopModule (
    output reg one
);

    // Single-state state machine
    always @(*) begin
        one = 1'b1;  // Always in the "output high" state
    end

endmodule