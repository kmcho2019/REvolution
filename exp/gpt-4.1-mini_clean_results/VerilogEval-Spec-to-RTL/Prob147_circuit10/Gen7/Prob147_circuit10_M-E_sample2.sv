module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output reg state
);

    wire next_state;

    // Next state logic:
    // - If currently in state=1, stay unless both a and b are 1 (then reset to 0)
    // - If currently in state=0, set to 1 if b=1 and a=0, else stay 0
    assign next_state = (state & ~(a & b)) | (~state & b & ~a);

    // Output q depends on state and inputs:
    // - q=1 when state=1 and (a=0 or b=0)
    // - or when state=0 and a=1 and b=1
    assign q = (state & (~a | ~b)) | (~state & a & b);

    always @(posedge clk) begin
        state <= next_state;
    end

endmodule