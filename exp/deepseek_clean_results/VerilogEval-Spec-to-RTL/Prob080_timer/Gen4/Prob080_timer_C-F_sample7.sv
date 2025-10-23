module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire [9:0] next_counter;

    // Optimized next state logic:
    // - Load has priority
    // - Otherwise decrement (will naturally stop at 0)
    assign next_counter = load ? data : (counter - 1);

    // Sequential state update
    always @(posedge clk) begin
        counter <= next_counter;
    end

    // Terminal count is simple zero detection
    assign tc = (counter == 0);

endmodule