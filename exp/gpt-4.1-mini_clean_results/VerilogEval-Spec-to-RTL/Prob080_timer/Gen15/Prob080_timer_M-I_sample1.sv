module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire enable_decrement;
    wire [9:0] next_counter;

    // Enable decrement only when counter is nonzero and load is low
    assign enable_decrement = (counter != 0) && !load;

    // Next counter value logic:
    // - Load data if load asserted
    // - Else if enabled, decrement by 1
    // - Else hold current value
    assign next_counter = load ? data :
                          enable_decrement ? (counter - 1) :
                          counter;

    always @(posedge clk) begin
        counter <= next_counter;
    end

    assign tc = (counter == 0);

endmodule