module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    reg [1:0] state_shift;  // '01' = OFF, '10' = ON
    
    always @(posedge clk) begin
        if (reset)
            state_shift <= 2'b01;  // Reset to OFF state
        else begin
            case (state_shift)
                2'b01: state_shift <= j ? 2'b10 : 2'b01;  // OFF→ON if j=1
                2'b10: state_shift <= k ? 2'b01 : 2'b10;  // ON→OFF if k=1
                default: state_shift <= 2'b01;            // Handle invalid states
            endcase
        end
    end
    
    assign out = state_shift[1];  // Output is MSB of shift register

endmodule