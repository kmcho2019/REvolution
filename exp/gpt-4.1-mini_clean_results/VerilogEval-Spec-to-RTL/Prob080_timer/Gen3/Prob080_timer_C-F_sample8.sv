module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;

    always @(posedge clk) begin
        if (load) 
            counter <= data;
        else if (|counter) 
            counter <= counter - 1;
        // no else needed: hold zero state
    end

    assign tc = ~|counter;

endmodule