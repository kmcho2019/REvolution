module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;
reg [9:0] next_counter;

// Combinational logic to determine next counter value
always @(*) begin
    if (load)
        next_counter = data;
    else if (counter != 0)
        next_counter = counter - 1;
    else
        next_counter = 0;
end

// Sequential logic to update counter at clock edge
always @(posedge clk) begin
    counter <= next_counter;
end

assign tc = (counter == 0);

endmodule