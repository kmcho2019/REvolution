module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    reg [1:0] counter;
    
    always @(posedge clk) begin
        if (reset)
            counter <= 2'b00;
        else begin
            case ({j,k})
                2'b10: counter <= (counter == 2'b11) ? 2'b11 : counter + 1;
                2'b01: counter <= (counter == 2'b00) ? 2'b00 : counter - 1;
                default: counter <= counter;
            endcase
        end
    end
    
    assign out = (counter == 2'b11);

endmodule