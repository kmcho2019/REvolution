module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire [9:0] next_counter;
    wire should_decrement;
    
    assign should_decrement = (~load) & (|counter);  // Decrement when not loading and counter not zero
    assign next_counter = load ? data : (counter - should_decrement);
    
    always @(posedge clk) begin
        counter <= next_counter;
    end

    assign tc = (counter == 0);

endmodule