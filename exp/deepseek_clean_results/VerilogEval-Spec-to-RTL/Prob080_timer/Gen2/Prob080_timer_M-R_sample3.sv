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
                        (counter != 0) ? (counter - 1) : counter;

    // Sequential state update
    always @(posedge clk) begin
        counter <= next_counter;
    end

    // Output logic
    assign tc = (counter == 0);

endmodule