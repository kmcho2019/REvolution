module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire [9:0] next_counter = load ? data : (~|counter) ? 10'b0 : counter - 1;

    always @(posedge clk) begin
        counter <= next_counter;
    end

    assign tc = ~|counter;

endmodule