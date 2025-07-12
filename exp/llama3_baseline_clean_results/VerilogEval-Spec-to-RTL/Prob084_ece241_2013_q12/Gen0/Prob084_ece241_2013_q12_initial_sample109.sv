module TopModule(clk, enable, S, A, B, C, Z);
    input clk;
    input enable;
    input S;
    input A;
    input B;
    input C;
    output Z;

    reg [7:0] Q;

    always @(posedge clk) begin
        if (enable) begin
            Q[7:1] <= Q[6:0];
            Q[0] <= S;
        end
    end

    wire [7:0] decoded;
    assign decoded[0] = ~A & ~B & ~C;
    assign decoded[1] = ~A & ~B & C;
    assign decoded[2] = ~A & B & ~C;
    assign decoded[3] = ~A & B & C;
    assign decoded[4] = A & ~B & ~C;
    assign decoded[5] = A & ~B & C;
    assign decoded[6] = A & B & ~C;
    assign decoded[7] = A & B & C;

    assign Z = (decoded[0] & Q[0]) | (decoded[1] & Q[1]) | (decoded[2] & Q[2]) | (decoded[3] & Q[3]) | 
               (decoded[4] & Q[4]) | (decoded[5] & Q[5]) | (decoded[6] & Q[6]) | (decoded[7] & Q[7]);

endmodule