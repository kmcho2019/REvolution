// Module for assign-based XOR
module xor_assign(
    input a,
    input b,
    output out
);
    
    assign out = a ^ b;
    
endmodule

// Module for combinational always block XOR
module xor_always_comb(
    input a,
    input b,
    output out
);
    
    always_comb begin
        out = a ^ b;
    end
    
endmodule

// Module for flip-flop based XOR
module xor_ff(
    input clk,
    input a,
    input b,
    output reg out
);
    
    always_ff @(posedge clk) begin
        out <= a ^ b;
    end
    
endmodule

// TopModule with configurability
module TopModule(
    input clk,
    input [1:0] ctrl, // Control input to select XOR implementation
    input a,
    input b,
    output out
);
    
    wire out_assign;
    wire out_always_comb;
    wire out_always_ff;
    
    // Instantiate XOR modules
    xor_assign u_xor_assign(
        .a(a),
        .b(b),
        .out(out_assign)
    );
    
    xor_always_comb u_xor_always_comb(
        .a(a),
        .b(b),
        .out(out_always_comb)
    );
    
    xor_ff u_xor_ff(
        .clk(clk),
        .a(a),
        .b(b),
        .out(out_always_ff)
    );
    
    // Multiplexer to select output based on control input
    always_comb begin
        case(ctrl)
            2'b00: out = out_assign;
            2'b01: out = out_always_comb;
            2'b10: out = out_always_ff;
            default: out = 1'b0; // Default output
        endcase
    end
    
endmodule