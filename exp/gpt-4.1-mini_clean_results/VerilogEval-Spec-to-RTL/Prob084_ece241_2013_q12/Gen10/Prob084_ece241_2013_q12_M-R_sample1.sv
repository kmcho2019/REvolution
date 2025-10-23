module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output reg Z
);

    reg [7:0] Q;
    reg [7:0] next_Q;

    // Next-state logic for the shift register
    integer i;
    always @(*) begin
        next_Q[0] = S;
        for (i = 1; i < 8; i = i + 1)
            next_Q[i] = Q[i-1];
    end

    // Sequential update on positive clock edge with enable
    always @(posedge clk) begin
        if (enable)
            Q <= next_Q;
    end

    // Combinational multiplexer to select output Z based on {A,B,C}
    always @(*) begin
        case ({A,B,C})
            3'b000: Z = Q[0];
            3'b001: Z = Q[1];
            3'b010: Z = Q[2];
            3'b011: Z = Q[3];
            3'b100: Z = Q[4];
            3'b101: Z = Q[5];
            3'b110: Z = Q[6];
            3'b111: Z = Q[7];
            default: Z = 1'b0; // default case, though not strictly necessary
        endcase
    end

endmodule