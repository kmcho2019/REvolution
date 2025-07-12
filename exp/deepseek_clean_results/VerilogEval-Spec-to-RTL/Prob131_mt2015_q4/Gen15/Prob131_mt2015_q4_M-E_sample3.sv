module ConfigurableLogicUnit(
    input x,
    input y,
    input mode,  // 0 for ModuleA, 1 for ModuleB
    output reg z
);
    // LUT for ModuleB functionality
    reg [3:0] b_lut = 4'b1001; // Truth table: 00->1, 01->0, 10->0, 11->1
    
    always @(*) begin
        if (!mode) begin
            // ModuleA functionality: (x^y)&x optimized to x&~y
            z = x & ~y;
        end else begin
            // ModuleB functionality via LUT
            case ({x,y})
                2'b00: z = b_lut[0];
                2'b01: z = b_lut[1];
                2'b10: z = b_lut[2];
                2'b11: z = b_lut[3];
            endcase
        end
    end
endmodule

module TopModule(
    input x,
    input y,
    input clk,
    input enable,
    output reg z
);
    reg [1:0] state = 0;
    wire a_out, b_out;
    reg mode = 0;
    reg compute_en = 0;
    
    // Single configurable logic unit
    ConfigurableLogicUnit clu(
        .x(x),
        .y(y),
        .mode(mode),
        .z(compute_en ? (mode ? b_out : a_out) : 1'b0)
    );
    
    // Pipeline registers
    reg or_in, and_in;
    reg stage1_out, stage2_out;
    
    always @(posedge clk) if (enable) begin
        case (state)
            0: begin  // Compute ModuleA
                mode <= 0;
                compute_en <= 1;
                state <= 1;
            end
            1: begin  // Store ModuleA result
                or_in <= a_out;
                and_in <= a_out;
                mode <= 1;  // Switch to ModuleB
                state <= 2;
            end
            2: begin  // Compute ModuleB
                compute_en <= 1;
                state <= 3;
            end
            3: begin  // Final computation
                or_in <= or_in | b_out;
                and_in <= and_in & b_out;
                z <= or_in ^ and_in;
                state <= 0;
                compute_en <= 0;
            end
        endcase
    end else begin
        compute_en <= 0;
        z <= 1'b0;
    end
endmodule