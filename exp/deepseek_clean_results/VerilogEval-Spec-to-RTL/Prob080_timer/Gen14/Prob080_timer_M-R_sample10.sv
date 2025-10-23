module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    reg [9:0] next_counter;

    // Combinational logic for next state
    always @(*) begin
        if (load)
            next_counter = data;
        else if (~|counter)
            next_counter = 10'b0;
        else
            next_counter = counter - 1;
    end

    // Sequential logic for state update
    always @(posedge clk) begin
        counter <= next_counter;
    end

    assign tc = ~|counter;

endmodule