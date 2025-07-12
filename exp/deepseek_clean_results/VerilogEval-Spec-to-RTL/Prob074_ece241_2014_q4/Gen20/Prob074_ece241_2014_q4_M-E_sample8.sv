module TopModule (
    input clk,
    input x,
    output reg z
);

    // Stage 1: Gate outputs
    wire xor_gate, and_gate, or_gate;
    
    // Stage 2: Flip-flop outputs (feedback paths)
    reg xor_ff, and_ff, or_ff;
    
    // Stage 3: Final NOR output register
    reg nor_out;

    // Gate implementations (no direct feedback)
    assign xor_gate = x ^ xor_ff;
    assign and_gate = x & (~and_ff);
    assign or_gate  = x | (~or_ff);

    // Three-input NOR of flip-flop outputs
    always @(*) begin
        nor_out = ~(xor_ff | and_ff | or_ff);
    end

    // Synchronous logic with proper reset
    always @(posedge clk) begin
        // Update flip-flops with gate outputs
        xor_ff <= xor_gate;
        and_ff <= and_gate;
        or_ff  <= or_gate;
        
        // Register final output
        z <= nor_out;
    end

    // Initial state (for simulation)
    initial begin
        xor_ff = 1'b0;
        and_ff = 1'b0;
        or_ff  = 1'b0;
        z      = 1'b1;  // NOR of all zeros
    end

endmodule