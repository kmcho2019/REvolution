module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire shift_enable = ~load & (counter != 10'b1) & (counter != 10'b0);
    wire [9:0] next_counter = load ? data : 
                            shift_enable ? {1'b0, counter[9:1]} : 
                            counter;

    always @(posedge clk) begin
        counter <= next_counter;
    end

    assign tc = (counter == 10'b0);

endmodule