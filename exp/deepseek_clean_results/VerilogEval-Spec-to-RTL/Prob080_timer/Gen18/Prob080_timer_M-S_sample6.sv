module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    
    always @(posedge clk) begin
        counter <= load ? data : (|counter) ? (counter - 1) : 0;
    end

    assign tc = (counter == 0);

endmodule