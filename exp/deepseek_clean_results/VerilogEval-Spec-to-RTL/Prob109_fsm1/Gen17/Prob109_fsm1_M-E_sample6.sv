module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    reg [1:0] state_shift; // [1] = B, [0] = A
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_shift <= 2'b10; // Reset to B
        end
        else begin
            case (state_shift)
                2'b10: state_shift <= in ? 2'b10 : 2'b01; // B->B if 1, B->A if 0
                2'b01: state_shift <= in ? 2'b01 : 2'b10; // A->A if 1, A->B if 0
                default: state_shift <= 2'b10; // Safety net
            endcase
        end
    end
    
    assign out = state_shift[1]; // Output is MSB (1 for B, 0 for A)
    
endmodule