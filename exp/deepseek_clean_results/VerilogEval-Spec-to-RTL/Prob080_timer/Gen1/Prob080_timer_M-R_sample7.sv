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
                        (counter != 0) ? (counter - 1) : counter;

    // Sequential logic for counter update
    always @(posedge clk) begin
        counter <= next_counter;
    end

    // Output logic
    assign tc = (counter == 0);

endmodule