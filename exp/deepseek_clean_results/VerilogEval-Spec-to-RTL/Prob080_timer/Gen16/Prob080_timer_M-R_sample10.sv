module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire [9:0] next_counter;

    // Combinational next-state logic
    assign next_counter = load ? data : 
                         (~|counter) ? 10'b0 : 
                         counter - 1;

    // Sequential storage
    always @(posedge clk) begin
        counter <= next_counter;
    end

    // Terminal count detection
    assign tc = ~|counter;

endmodule