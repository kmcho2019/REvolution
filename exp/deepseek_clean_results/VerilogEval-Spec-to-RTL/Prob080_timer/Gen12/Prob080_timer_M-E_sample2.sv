module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    reg is_zero;
    
    always @(posedge clk) begin
        if (load) begin
            counter <= data;
            is_zero <= (data == 10'b0);
        end
        else if (!is_zero) begin
            counter <= counter - 1;
            is_zero <= (counter == 10'b1);
        end
    end

    assign tc = is_zero;

endmodule