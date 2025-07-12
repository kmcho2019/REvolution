module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire [9:0] next_counter;
    wire load_or_zero = (counter == 0);
    
    // Next counter value logic
    assign next_counter = load ? data : 
                        load_or_zero ? 0 : 
                        counter - 1;

    // D flip-flop implementation
    always @(posedge clk) begin
        counter <= next_counter;
    end

    // Terminal count output
    assign tc = (counter == 0);

endmodule