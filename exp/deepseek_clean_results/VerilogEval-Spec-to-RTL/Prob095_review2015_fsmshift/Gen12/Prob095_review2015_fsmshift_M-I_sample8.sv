module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [1:0] count;
    
    assign shift_ena = (reset || (count != 2'b11));
    
    always @(posedge clk) begin
        if (reset) begin
            count <= 2'b00;
        end else if (count != 2'b11) begin
            count <= count + 1;
        end
    end

endmodule