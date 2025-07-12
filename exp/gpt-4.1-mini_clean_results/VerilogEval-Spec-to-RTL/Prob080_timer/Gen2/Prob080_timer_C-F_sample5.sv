module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;

    always @(posedge clk) begin
        if (load) begin
            // Load the counter with input data on load
            counter <= data;
        end else if (|counter) begin
            // Decrement counter only if nonzero and load is low
            counter <= counter - 10'd1;
        end
        // else hold zero (do not toggle register)
    end

    // Terminal count asserted when counter is zero; optimized zero detect
    assign tc = ~|counter;

endmodule