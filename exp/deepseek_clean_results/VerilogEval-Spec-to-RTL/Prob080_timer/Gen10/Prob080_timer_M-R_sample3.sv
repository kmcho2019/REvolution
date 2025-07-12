module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire [9:0] next_counter;
    wire counter_zero;

    // Combinational logic
    assign counter_zero = (counter == 10'b0);
    assign next_counter = load ? data : 
                        (counter_zero ? 10'b0 : counter - 10'b1);

    // Sequential logic (D flip-flop)
    always @(posedge clk) begin
        counter <= next_counter;
    end

    // Terminal count output
    assign tc = counter_zero;

endmodule