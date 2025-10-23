module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire counter_zero;
    wire clk_enable = ~counter_zero || load;

    // Hierarchical zero detection
    wire [4:0] upper = counter[9:5];
    wire [4:0] lower = counter[4:0];
    assign counter_zero = (upper == 5'b0) && (lower == 5'b0);

    always @(posedge clk) begin
        if (load) begin
            counter <= data;
        end
        else if (clk_enable && !counter_zero) begin
            counter <= counter - 1;
        end
    end

    assign tc = counter_zero;

endmodule