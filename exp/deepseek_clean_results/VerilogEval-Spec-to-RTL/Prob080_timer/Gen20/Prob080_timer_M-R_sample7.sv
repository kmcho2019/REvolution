module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire [9:0] decremented = counter - 1'b1;
    wire [9:0] next_counter;

    assign next_counter = load ? data : 
                         (counter == 0) ? 10'b0 : 
                         decremented;

    assign tc = (counter == 0);

    always @(posedge clk) begin
        counter <= next_counter;
    end

endmodule