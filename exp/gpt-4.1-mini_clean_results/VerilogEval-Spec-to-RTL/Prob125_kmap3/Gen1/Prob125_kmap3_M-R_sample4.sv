module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Inputs concatenated for easy case analysis:
    // We'll order inputs as {c,d,a,b} to correspond to cd and ab axes in the K-map.
    wire [3:0] idx = {c, d, a, b};

    reg out_reg;
    always @(*) begin
        case(idx)
            // cd=00 -> c=0,d=0
            4'b0001: out_reg = 1'b0; // ab=01 -> output 0
            4'b0000: out_reg = 1'b0; // ab=00 -> output 0 (from map: 0)
            4'b0010: out_reg = 1'b1; // ab=10 -> output 1
            4'b0011: out_reg = 1'b1; // ab=11 -> output 1
            // cd=01 -> c=0,d=1
            4'b0100: out_reg = 1'b0; // ab=00 -> output 0
            4'b0101: out_reg = 1'b0; // ab=01 -> output 0
            4'b0110: out_reg = 1'b0; // ab=10 -> d (don't care), assign 0
            4'b0111: out_reg = 1'b0; // ab=11 -> d (don't care), assign 0
            // cd=11 -> c=1,d=1
            4'b1100: out_reg = 1'b0; // ab=00 -> output 0
            4'b1101: out_reg = 1'b1; // ab=01 -> output 1
            4'b1110: out_reg = 1'b1; // ab=10 -> output 1
            4'b1111: out_reg = 1'b1; // ab=11 -> output 1
            // cd=10 -> c=1,d=0
            4'b1000: out_reg = 1'b0; // ab=00 -> output 0
            4'b1001: out_reg = 1'b1; // ab=01 -> output 1
            4'b1010: out_reg = 1'b1; // ab=10 -> output 1
            4'b1011: out_reg = 1'b1; // ab=11 -> output 1
            default: out_reg = 1'b0; // Default output 0 for undefined states
        endcase
    end

    assign out = out_reg;

endmodule