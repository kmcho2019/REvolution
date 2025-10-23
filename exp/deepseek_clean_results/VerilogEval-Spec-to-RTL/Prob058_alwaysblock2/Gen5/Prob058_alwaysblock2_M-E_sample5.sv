module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);

    // XOR core submodule with configurable registration
    module XORCore #(parameter REGISTERED = 0) (
        input clk,
        input a,
        input b,
        output reg out
    );
        wire xor_result = a ^ b;
        
        if (REGISTERED) begin
            always_ff @(posedge clk) begin
                out <= xor_result;
            end
        end else begin
            always_comb begin
                out = xor_result;
            end
        end
    endmodule

    // Direct assignment implementation
    assign out_assign = a ^ b;
    
    // Combinational always block implementation
    XORCore #(.REGISTERED(0)) comb_xor (
        .clk(clk),
        .a(a),
        .b(b),
        .out(out_always_comb)
    );
    
    // Sequential implementation
    XORCore #(.REGISTERED(1)) seq_xor (
        .clk(clk),
        .a(a),
        .b(b),
        .out(out_always_ff)
    );

endmodule