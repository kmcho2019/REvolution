module TopModule (
    input clk,
    input L,
    input q_in,     // Current bit value
    input r_in,     // Load value
    input op_in,    // Operation input (q1 for bit 0, q0 for bit 1)
    input mode,     // 0: pass-through, 1: XOR operation
    output reg Q
);

    // Operation logic
    wire operation_result = mode ? (op_in ^ q_in) : op_in;
    
    // Mux selects between load and operation
    wire next_Q = L ? r_in : operation_result;

    // Sequential logic for flip-flop
    always @(posedge clk) begin
        Q <= next_Q;
    end

endmodule