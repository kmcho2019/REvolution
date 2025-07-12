module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire [9:0] next_counter;
    
    // Next counter value logic:
    // - Load new value when load=1
    // - Decrement when not zero and not loading
    // - Hold at zero otherwise
    assign next_counter = load ? data :
                         (counter != 0) ? (counter - 1) :
                         10'b0;

    // Single D flip-flop for the counter
    always @(posedge clk) begin
        counter <= next_counter;
    end

    // Terminal count is simply counter==0
    assign tc = (counter == 0);

endmodule