module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    // Parallel prefix network nodes
    wire [15:0] gen, prop;
    wire [15:0][7:0] rem_out;
    wire [15:0] quot;

    // Stage 0: Bit-wise computation
    genvar i;
    generate
        for (i = 15; i >= 0; i = i - 1) begin : bit_stage
            // For each bit position, compute if we can subtract B
            wire [8:0] current = (i == 15) ? {1'b0, A[15]} : {rem_out[i+1], A[i]};
            assign gen[i] = (current >= {1'b0, B});
            assign prop[i] = (i != 15); // All but MSB can propagate
            
            // Compute remainder and quotient for this bit
            assign rem_out[i] = gen[i] ? (current - B) : current[7:0];
            assign quot[i] = gen[i];
        end
    endgenerate

    // Parallel prefix network (log2(16) = 4 stages)
    wire [15:0] stage1_gen, stage1_prop;
    wire [15:0][7:0] stage1_rem;

    // Stage 1: Combine pairs of 1 bit
    generate
        for (i = 0; i < 16; i = i + 2) begin : stage1
            if (i == 15) begin
                assign stage1_gen[i] = gen[i];
                assign stage1_prop[i] = prop[i];
                assign stage1_rem[i] = rem_out[i];
            end else begin
                assign stage1_gen[i] = gen[i] | (prop[i] & gen[i+1]);
                assign stage1_prop[i] = prop[i] & prop[i+1];
                assign stage1_rem[i] = gen[i] ? rem_out[i] : 
                                     (gen[i+1] ? (rem_out[i+1] - B) : rem_out[i+1];
            end
        end
    endgenerate

    // Stage 2: Combine pairs of 2 bits
    wire [15:0] stage2_gen, stage2_prop;
    wire [15:0][7:0] stage2_rem;

    generate
        for (i = 0; i < 16; i = i + 4) begin : stage2
            if (i >= 12) begin
                assign stage2_gen[i] = stage1_gen[i];
                assign stage2_prop[i] = stage1_prop[i];
                assign stage2_rem[i] = stage1_rem[i];
            end else begin
                assign stage2_gen[i] = stage1_gen[i] | (stage1_prop[i] & stage1_gen[i+2]);
                assign stage2_prop[i] = stage1_prop[i] & stage1_prop[i+2];
                assign stage2_rem[i] = stage1_gen[i] ? stage1_rem[i] : 
                                     (stage1_gen[i+2] ? (stage1_rem[i+2] - B) : stage1_rem[i+2]);
            end
        end
    endgenerate

    // Stage 3: Combine pairs of 4 bits
    wire [15:0] stage3_gen, stage3_prop;
    wire [15:0][7:0] stage3_rem;

    generate
        for (i = 0; i < 16; i = i + 8) begin : stage3
            assign stage3_gen[i] = stage2_gen[i] | (stage2_prop[i] & stage2_gen[i+4]);
            assign stage3_prop[i] = stage2_prop[i] & stage2_prop[i+4];
            assign stage3_rem[i] = stage2_gen[i] ? stage2_rem[i] : 
                                 (stage2_gen[i+4] ? (stage2_rem[i+4] - B) : stage2_rem[i+4]);
        end
    endgenerate

    // Final stage: Combine all 16 bits
    wire final_gen = stage3_gen[0] | (stage3_prop[0] & stage3_gen[8]);
    wire [7:0] final_rem = stage3_gen[0] ? stage3_rem[0] : 
                          (stage3_gen[8] ? (stage3_rem[8] - B) : stage3_rem[8]);

    // Output assignment
    assign result = quot;
    assign odd = {8'b0, final_rem};

endmodule