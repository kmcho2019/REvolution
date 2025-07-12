module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;

    wire update = load | (counter != 0); // only update when loading or counting down
    wire [9:0] decremented = counter - 1;

    always @(posedge clk) begin
        if (load)
            counter <= data;
        else if (counter != 0)
            counter <= decremented;
        // else hold counter at zero (no toggling)
    end

    assign tc = (counter == 0);

endmodule