// TopModule implementation
module TopModule(
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);
    
    // Use assign statement to generate XOR output directly
    assign out_assign = a ^ b;
    
    // Use combinational always block to generate XOR output directly
    always_comb begin
        out_always_comb = a ^ b;
    end
    
    // Use clocked always block to implement state machine
    reg [1:0] state;
    always_ff @(posedge clk) begin
        case (state)
            2'b00: begin
                out_always_ff <= 1'b0;
                state <= 2'b01;
            end
            2'b01: begin
                out_always_ff <= a ^ b;
                state <= 2'b10;
            end
            2'b10: begin
                state <= 2'b00;
            end
            default: begin
                state <= 2'b00;
            end
        endcase
    end
    
endmodule