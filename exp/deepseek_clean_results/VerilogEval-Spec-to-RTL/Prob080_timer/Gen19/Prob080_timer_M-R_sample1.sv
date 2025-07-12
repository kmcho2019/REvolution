module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire load_condition = load;
    wire decrement_condition = ~load && (counter != 0);
    wire [9:0] next_counter = load_condition ? data : 
                            decrement_condition ? (counter - 1) : 
                            counter;

    always @(posedge clk) begin
        counter <= next_counter;
    end

    assign tc = (counter == 0);

endmodule