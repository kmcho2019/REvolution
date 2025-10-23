module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;

    wire count_enable = (~load) & (counter != 0);

    always @(posedge clk) begin
        if (load) begin
            counter <= data;
        end else if (count_enable) begin
            counter <= counter - 1;
        end
        // else counter stays at zero, avoiding toggling
    end

    assign tc = (counter == 0);

endmodule