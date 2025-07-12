module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    assign tc = ~|counter;  // Efficient zero detection

    always @(posedge clk) begin
        if (load) begin
            counter <= data;
        end else if (!tc) begin
            counter <= counter - 1;
        end
        // Implicit else: counter remains 0
    end

endmodule