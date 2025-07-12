module DecrementUnit(
    input [9:0] counter_in,
    output [9:0] counter_out
);

    assign counter_out = (counter_in > 0) ? counter_in - 1 : 0;

endmodule

module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;
assign tc = (counter == 0);

DecrementUnit decrement_unit(
    .counter_in(counter),
    .counter_out(counter)
);

always @(posedge clk) begin
    if (load) counter <= data;
    else counter <= decrement_unit.counter_out;
end

endmodule