module TopModule (
    input [7:0] in,
    output reg parity
);
    reg [2:0] count;
    reg [7:0] shift_reg;
    
    initial begin
        parity = 0;
        count = 0;
        shift_reg = in;
    end
    
    always @(posedge clk) begin
        if (count < 7) begin
            parity <= parity ^ shift_reg[0];
            shift_reg <= shift_reg >> 1;
            count <= count + 1;
        end else begin
            parity <= parity ^ shift_reg[0];  // Final bit
        end
    end
endmodule