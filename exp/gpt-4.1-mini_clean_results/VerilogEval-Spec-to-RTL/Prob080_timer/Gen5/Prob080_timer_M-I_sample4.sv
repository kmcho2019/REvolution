module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;

    always @(posedge clk) begin
        if (load) begin
            counter <= data;
        end else if (counter != 0) begin
            counter <= counter - 1;
        end
        // else counter remains zero implicitly, no need to assign again
    end

    // terminal count asserted when counter is zero, implemented with OR reduction and inversion for lower logic complexity
    assign tc = ~|counter;

endmodule