module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output reg tc
);

    reg [9:0] counter;
    wire enable = (counter != 0) && !load;
    wire [9:0] next_counter = load ? data : 
                            enable ? counter - 1 : 
                            counter;

    always @(posedge clk) begin
        counter <= next_counter;
        tc <= (next_counter == 0);
    end

endmodule