module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    wire [9:0] counter;
    reg [9:0] counter_ff;
    wire [9:0] next_counter;

    // Combinational next counter logic
    assign next_counter = load ? data : (~|counter_ff) ? 0 : counter_ff - 1;

    // Clock-gated assignment for the counter (acts as DFF)
    assign counter = (posedge clk) ? next_counter : counter_ff;

    // Store the value between clock edges
    always @(*) begin
        counter_ff = counter;
    end

    // Terminal count detection
    assign tc = ~|counter;

endmodule