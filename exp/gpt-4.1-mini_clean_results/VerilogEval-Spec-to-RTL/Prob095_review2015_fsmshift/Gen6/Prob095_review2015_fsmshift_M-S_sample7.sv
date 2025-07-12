module TopModule (
    input clk,
    input reset,
    output shift_ena
);
    reg [2:0] count;

    always @(posedge clk) begin
        if (reset) 
            count <= 3'd4;
        else if (count != 3'd0)
            count <= count - 1;
    end

    assign shift_ena = (count != 3'd0);

endmodule