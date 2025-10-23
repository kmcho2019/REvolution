module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding using parameters for clarity
    localparam B = 1'b0;
    localparam A = 1'b1;

    reg state;
    wire next_state;
    wire out_wire;

    // Next state combinational logic
    assign next_state = (state == B) ? (in ? B : A) :  // From B
                        (in ? A : B);                  // From A

    // Output is purely based on current state (Moore)
    assign out_wire = (state == B) ? 1'b1 : 1'b0;

    // Sequential state update with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= B;
        else
            state <= next_state;
    end

    assign out = out_wire;

endmodule