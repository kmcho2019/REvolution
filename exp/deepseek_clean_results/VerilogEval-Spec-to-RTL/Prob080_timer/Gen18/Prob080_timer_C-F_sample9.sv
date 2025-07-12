module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire counter_zero = ~|counter;
    
    // Combinational next state logic
    wire [9:0] next_counter = load ? data : 
                             counter_zero ? 10'b0 : counter - 1;

    // Sequential state update
    always @(posedge clk) begin
        counter <= next_counter;
    end

    // Output logic
    assign tc = counter_zero;

endmodule