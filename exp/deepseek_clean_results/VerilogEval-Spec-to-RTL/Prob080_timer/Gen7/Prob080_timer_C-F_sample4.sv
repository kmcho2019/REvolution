module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire [9:0] next_counter;

    // Optimized next counter value calculation
    assign next_counter = load ? data : (~|counter) ? 0 : counter - 1;

    // Single DFF for sequential logic
    always @(posedge clk) begin
        counter <= next_counter;
    end

    // Efficient terminal count using reduction OR
    assign tc = ~|counter;

endmodule