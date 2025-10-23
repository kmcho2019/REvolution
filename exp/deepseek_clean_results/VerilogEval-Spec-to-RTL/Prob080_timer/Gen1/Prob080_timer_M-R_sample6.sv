module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    wire [9:0] next_counter;
    reg [9:0] counter;

    // Combinational logic for next counter value
    assign next_counter = load ? data : 
                         (counter != 0) ? (counter - 1) : counter;

    // Single D flip-flop for the counter
    always @(posedge clk) begin
        counter <= next_counter;
    end

    // Terminal count output
    assign tc = (counter == 0);

endmodule