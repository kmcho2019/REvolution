module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    // State encoding as a single bit:
    // 0 = WAIT_FOR_FIRST_ONE
    // 1 = INVERT_BITS
    reg state;

    // Next state logic
    wire next_state = (state == 1'b0) ? (x ? 1'b1 : 1'b0) : 1'b1;

    // Output logic depends only on current state and input (Moore machine)
    wire output_z = (state == 1'b0) ? x : ~x;

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0; // WAIT_FOR_FIRST_ONE
        end else begin
            state <= next_state;
        end
    end

    // Output assigned from combinational logic
    assign z = output_z;

endmodule