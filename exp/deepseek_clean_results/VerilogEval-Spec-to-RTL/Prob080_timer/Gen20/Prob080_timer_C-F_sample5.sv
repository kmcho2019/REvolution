module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire [9:0] next_counter = load ? data : (|counter) ? counter - 1 : 10'b0;

    always @(posedge clk) begin
        counter <= next_counter;
    end

    assign tc = ~|counter;

endmodule