module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;

    always @(posedge clk) begin
        if (load) begin
            counter <= data;  // Load the counter
        end else if (counter != 0) begin
            counter <= counter - 1;  // Decrement if not zero
        end
        // else hold counter at zero
    end

    assign tc = (counter == 0);

endmodule