// Define a parameterized module for the XOR gate
module xor_param #(
    parameter xor_type = "assign", // assign, always_comb, or always_ff
    parameter clock_edge = "posedge", // posedge or negedge
    parameter has_reset = 0 // 0 or 1
)(
    input clk,
    input a,
    input b,
    output reg out
);

    if (xor_type == "assign") begin
        assign out = a ^ b;
    end else if (xor_type == "always_comb") begin
        always_comb begin
            out = a ^ b;
        end
    end else if (xor_type == "always_ff") begin
        if (has_reset == 1) begin
            always_ff @(posedge clk or negedge clk) begin
                if (clock_edge == "posedge" && clk) begin
                    out <= a ^ b;
                end else if (clock_edge == "negedge" &&!clk) begin
                    out <= a ^ b;
                end
            end
        end else begin
            always_ff @(posedge clk) begin
                out <= a ^ b;
            end
        end
    end

endmodule

// TopModule implementation
module TopModule(
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);

    // Instantiate the parameterized XOR gate modules
    xor_param #(
       .xor_type("assign")
    ) u_assign(
       .clk(1'b0), // Not used for assign type
       .a(a),
       .b(b),
       .out(out_assign)
    );

    xor_param #(
       .xor_type("always_comb")
    ) u_always_comb(
       .clk(1'b0), // Not used for combinational always block
       .a(a),
       .b(b),
       .out(out_always_comb)
    );

    xor_param #(
       .xor_type("always_ff"),
       .has_reset(0)
    ) u_always_ff(
       .clk(clk),
       .a(a),
       .b(b),
       .out(out_always_ff)
    );

endmodule