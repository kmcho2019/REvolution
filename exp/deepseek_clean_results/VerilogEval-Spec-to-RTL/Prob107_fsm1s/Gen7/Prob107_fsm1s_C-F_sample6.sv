module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State definitions with parameters for clarity
    reg state;
    localparam B = 1'b0;
    localparam A = 1'b1;

    // State transitions - optimal XOR-like logic
    always @(posedge clk) begin
        if (reset)
            state <= B;  // Synchronous reset to state B
        else
            state <= state ? in : ~in;  // Efficient state transition
    end

    // Output assignment - minimal logic
    assign out = ~state;  // out=1 when state=B (0)

endmodule