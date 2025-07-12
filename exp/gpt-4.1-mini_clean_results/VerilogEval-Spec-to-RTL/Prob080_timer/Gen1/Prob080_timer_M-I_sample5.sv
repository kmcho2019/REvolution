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
        end else if (|counter) begin
            counter <= counter - 1;
        end
        // else no assignment, counter holds zero
    end

    // tc asserted when counter == 0; equivalently when no bits are set
    assign tc = ~|counter;

endmodule