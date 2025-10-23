module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire [9:0] next_counter;

    // Combinational logic for next counter value
    assign next_counter = load ? data : 
                        (|counter) ? (counter - 1) : 
                        counter;

    // Sequential logic (single flip-flop)
    always @(posedge clk) begin
        counter <= next_counter;
    end

    // Zero detection
    assign tc = (counter == 10'b0);

endmodule