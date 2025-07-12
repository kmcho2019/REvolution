module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

    localparam BEFORE_CARRY = 1'b0;
    localparam AFTER_CARRY  = 1'b1;

    reg state;

    // State register with asynchronous reset and direct input usage
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= BEFORE_CARRY;
        else
            state <= (state == BEFORE_CARRY && x) ? AFTER_CARRY : state;
    end

    // Moore output logic based on current state and input x
    always @(*) begin
        z = (state == BEFORE_CARRY) ? x : ~x;
    end

endmodule