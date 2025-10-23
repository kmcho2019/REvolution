module TopModule (
    output reg zero
);

    // Single-state state machine
    always @(*) begin
        zero = 1'b0;
    end

endmodule