module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output reg state
);

    wire next_state;

    // Next state logic based on current inputs and state
    assign next_state = (~a & ~b) ? state :
                        (~a &  b) ? 1'b1  :
                        ( a &  b) ? 1'b0  :
                                    ~state;

    // Output logic: q is high when state=1 and b=1, else 0
    assign q = state & b;

    always @(posedge clk) begin
        state <= next_state;
    end

endmodule