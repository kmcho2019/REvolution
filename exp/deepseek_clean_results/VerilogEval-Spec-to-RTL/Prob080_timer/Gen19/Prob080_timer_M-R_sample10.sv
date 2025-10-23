module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire [9:0] counter_next;
    wire counter_zero = (counter == 10'b0);
    wire counter_decrement = counter - 1'b1;

    assign counter_next = load ? data : 
                        counter_zero ? 10'b0 : 
                        counter_decrement;

    assign tc = counter_zero;

    always @(posedge clk) begin
        counter <= counter_next;
    end

endmodule