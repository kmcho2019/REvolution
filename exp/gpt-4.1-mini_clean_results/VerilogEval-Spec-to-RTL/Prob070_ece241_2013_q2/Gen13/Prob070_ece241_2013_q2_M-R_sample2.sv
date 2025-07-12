module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out_sop,
    output out_pos
);

    wire [3:0] in_vec = {a, b, c, d}; // MSB to LSB as given
    
    // out_sop combinational logic via case statement
    always @(*) begin
        case (in_vec)
            4'd2:  out_sop = 1'b1; // 0010
            4'd7:  out_sop = 1'b1; // 0111
            4'd15: out_sop = 1'b1; // 1111
            default: out_sop = 1'b0;
        endcase
    end

    // Minimal POS for out_pos can be implemented as complement of out_sop
    // But per problem, must be minimal POS expression.
    // Using derived POS: (a | ~b | ~c | d) & (a | b | c | ~d)
    // To avoid confusion, re-derive these using the same input vector order:
    // a,b,c,d = in_vec[3], in_vec[2], in_vec[1], in_vec[0]
    assign out_pos = (a | ~b | ~c | d) & (a | b | c | ~d);

endmodule