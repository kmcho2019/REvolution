module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire counter_enable = (counter != 0) && !load;
    wire [9:0] next_counter = load ? data : (counter - 1'b1);

    always @(posedge clk) begin
        if (load || counter_enable) begin
            counter <= next_counter;
        end
    end

    assign tc = (counter == 0);

endmodule