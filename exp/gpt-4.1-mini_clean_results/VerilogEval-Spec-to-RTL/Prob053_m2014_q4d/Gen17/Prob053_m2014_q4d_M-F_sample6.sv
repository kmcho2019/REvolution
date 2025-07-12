module TopModule (
    input clk,
    input in,
    output out
);

    reg prev_state;

    // Initialize prev_state to zero to avoid simulation startup mismatch
    initial begin
        prev_state = 1'b0;
    end

    // XOR combinational logic using prev_state instead of output port
    wire xor_val = in ^ prev_state;

    // Sequential logic updates prev_state at positive clock edge
    always @(posedge clk) begin
        prev_state <= xor_val;
    end

    // Output driven by the registered state
    assign out = prev_state;

endmodule