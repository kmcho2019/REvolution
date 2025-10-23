module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;

    always @(posedge clk) begin
        if (load) begin
            counter <= data;
        end else begin
            counter <= counter - (counter != 0);
        end
    end

    assign tc = (counter == 10'b0);

endmodule