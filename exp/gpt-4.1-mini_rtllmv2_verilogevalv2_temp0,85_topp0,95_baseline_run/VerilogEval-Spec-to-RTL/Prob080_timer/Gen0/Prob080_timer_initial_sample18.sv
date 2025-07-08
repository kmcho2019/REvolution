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
        end else if (counter != 10'd0) begin
            counter <= counter - 10'd1;
        end
        // else counter remains 0
    end

    assign tc = (counter == 10'd0);

endmodule