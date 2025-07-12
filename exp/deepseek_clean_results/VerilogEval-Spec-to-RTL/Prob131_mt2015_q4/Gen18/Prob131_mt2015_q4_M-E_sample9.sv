module ConfigurableLogicUnit(
    input x,
    input y,
    input mode,  // 0: ModuleA, 1: ModuleB
    output reg z
);
    // Shared XOR operation
    wire xy_xor;
    assign xy_xor = x ^ y;

    always @(*) begin
        case(mode)
            1'b0: z = x & ~y;  // ModuleA function
            1'b1: z = ~xy_xor; // ModuleB function
        endcase
    end
endmodule

module TopModule(
    input x,
    input y,
    output z
);
    // Control signals
    reg [1:0] phase;
    wire mode_a, mode_b;
    
    // Pipeline registers
    reg a_out, b_out;
    reg or_out, and_out;
    
    // Configurable logic unit
    ConfigurableLogicUnit clu(
        .x(x),
        .y(y),
        .mode(phase[1]),
        .z()
    );
    
    // 2-phase computation control
    assign mode_a = ~phase[1];
    assign mode_b = phase[1];
    
    always @(posedge clk) begin
        // Phase 1: Compute ModuleA and ModuleB results
        if (phase == 2'b00) begin
            a_out <= clu.z;  // Store ModuleA result
            phase <= 2'b01;
        end
        // Phase 2: Compute ModuleB result
        else if (phase == 2'b01) begin
            b_out <= clu.z;  // Store ModuleB result
            phase <= 2'b10;
        end
        // Phase 3: Combine results
        else if (phase == 2'b10) begin
            or_out <= a_out | b_out;
            and_out <= a_out & b_out;
            phase <= 2'b11;
        end
        // Phase 4: Final output
        else begin
            z <= or_out ^ and_out;
            phase <= 2'b00;
        end
    end
endmodule