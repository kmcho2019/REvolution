module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    reg [1:0] shift_reg;
    
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 2'b01;  // OFF state
        end
        else begin
            case ({j,k})
                2'b10: shift_reg <= {shift_reg[0], 1'b0};  // j=1: shift left (to ON)
                2'b01: shift_reg <= {1'b0, shift_reg[1]};  // k=1: shift right (to OFF)
                default: shift_reg <= shift_reg;           // hold state
            endcase
        end
    end
    
    assign out = shift_reg[1];  // MSB represents current state

endmodule