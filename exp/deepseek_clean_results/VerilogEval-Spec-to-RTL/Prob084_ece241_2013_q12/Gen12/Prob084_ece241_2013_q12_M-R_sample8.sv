module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);
    // 8-bit shift register implemented with continuous assignments
    reg [7:0] Q;
    wire [7:0] next_Q;
    
    assign next_Q = enable ? {Q[6:0], S} : Q;
    
    always @(posedge clk) begin
        Q <= next_Q;
    end

    // 8:1 mux implemented with case statement
    wire [2:0] sel = {A, B, C};
    reg out;
    
    always @(*) begin
        case (sel)
            3'b000: out = Q[0];
            3'b001: out = Q[1];
            3'b010: out = Q[2];
            3'b011: out = Q[3];
            3'b100: out = Q[4];
            3'b101: out = Q[5];
            3'b110: out = Q[6];
            3'b111: out = Q[7];
            default: out = 1'b0;
        endcase
    end
    
    assign Z = out;
endmodule