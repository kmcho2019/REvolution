module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;

    always @(posedge clk) begin
        if (load) begin
            counter <= data;        // Load counter with input data
        end else if (counter != 0) begin
            counter <= counter - 1; // Decrement counter when active
        end
        // else counter remains 0
    end

    assign tc = (counter == 0);

endmodule