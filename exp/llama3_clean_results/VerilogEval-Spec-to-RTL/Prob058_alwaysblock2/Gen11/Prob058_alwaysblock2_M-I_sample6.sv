// Define a separate module for the XOR gate
module xor_gate(
    input a,
    input b,
    output out
);
    
    assign out = a ^ b;
    
endmodule

// Define a module for the flip-flop with clock gating
module flip_flop(
    input clk,
    input en, // Enable signal for clock gating
    input d,
    output reg q
);
    
    always_ff @(posedge clk) begin
        if (en) begin
            q <= d; // Use non-blocking assignment to prevent race conditions
        end
    end
    
endmodule

// Define a module for the combinational always block
module xor_always_comb(
    input a,
    input b,
    output reg out
);
    
    always_comb begin
        out = a ^ b;
    end
    
endmodule

// TopModule implementation with clock gating for the flip-flop
module TopModule(
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);
    
    // Instantiate the XOR gate for out_assign
    xor_gate u_xor1(
      .a(a),
      .b(b),
      .out(out_assign)
    );
    
    // Instantiate the combinational always block for out_always_comb
    xor_always_comb u_always_comb1(
      .a(a),
      .b(b),
      .out(out_always_comb)
    );
    
    // Instantiate the XOR gate and flip-flop with clock gating for out_always_ff
    wire internal_xor_ff;
    xor_gate u_xor2(
      .a(a),
      .b(b),
      .out(internal_xor_ff)
    );
    
    // Use a constant enable signal for simplicity; in a real scenario, this could be a dynamic signal
    wire en = 1'b1; // Enable the flip-flop for demonstration purposes
    
    flip_flop u_ff(
      .clk(clk),
      .en(en), // Apply clock gating
      .d(internal_xor_ff),
      .q(out_always_ff)
    );
    
endmodule