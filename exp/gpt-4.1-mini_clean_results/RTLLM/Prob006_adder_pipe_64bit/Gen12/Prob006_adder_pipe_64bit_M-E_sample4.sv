module adder_pipe_64bit (
    input               clk,
    input               rst_n,
    input               i_en,
    input      [63:0]   adda,
    input      [63:0]   addb,
    output reg [64:0]   result,
    output reg          o_en
);

    // Number of bits/stages
    localparam WIDTH = 64;

    // Pipeline registers per bit: 
    // hold input operand bits for stage i
    reg adda_pipe [0:WIDTH-1];
    reg addb_pipe [0:WIDTH-1];
    // registered carry in for stage i
    reg carry_pipe [0:WIDTH];
    // sum bit registered at stage i
    reg sum_pipe [0:WIDTH-1];
    // pipeline enable shift register for i_en, depth WIDTH
    reg en_pipe [0:WIDTH];

    integer i;

    // Full adder combinational logic for each stage:
    // sum = adda_bit ^ addb_bit ^ carry_in
    // carry_out = (adda_bit & addb_bit) | (adda_bit & carry_in) | (addb_bit & carry_in)

    wire [WIDTH-1:0] adda_in_vec;
    wire [WIDTH-1:0] addb_in_vec;
    wire [WIDTH:0] carry_in_vec;
    wire [WIDTH-1:0] sum_out_vec;
    wire [WIDTH:0] carry_out_vec;

    // Connect input vectors from pipeline regs for combinational full adders
    // carry_in_vec[0] is carry_in for bit 0 (stage 0), always zero at input
    // For bit i: sum_out_vec[i] and carry_out_vec[i+1]
    // carry_out_vec[0] will be zero (dummy)

    assign carry_in_vec[0] = 1'b0;

    generate
        genvar bit_i;
        for (bit_i=0; bit_i < WIDTH; bit_i=bit_i+1) begin : full_adder_gen
            assign adda_in_vec[bit_i] = adda_pipe[bit_i];
            assign addb_in_vec[bit_i] = addb_pipe[bit_i];
            assign carry_in_vec[bit_i+1] = carry_out_vec[bit_i];

            assign sum_out_vec[bit_i] = adda_in_vec[bit_i] ^ addb_in_vec[bit_i] ^ carry_in_vec[bit_i];
            assign carry_out_vec[bit_i] = (adda_in_vec[bit_i] & addb_in_vec[bit_i]) 
                                       | (adda_in_vec[bit_i] & carry_in_vec[bit_i])
                                       | (addb_in_vec[bit_i] & carry_in_vec[bit_i]);
        end
    endgenerate

    // Pipeline process: registers update at each clock
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Clear pipeline registers and outputs
            for (i = 0; i < WIDTH; i = i + 1) begin
                adda_pipe[i]  <= 1'b0;
                addb_pipe[i]  <= 1'b0;
                sum_pipe[i]   <= 1'b0;
                carry_pipe[i] <= 1'b0;
                en_pipe[i]    <= 1'b0;
            end
            carry_pipe[WIDTH] <= 1'b0;
            en_pipe[WIDTH] <= 1'b0;

            result <= 0;
            o_en <= 1'b0;
        end else begin
            // Shift input operands bits into pipeline
            adda_pipe[0] <= adda[0];
            addb_pipe[0] <= addb[0];

            for (i=1; i < WIDTH; i = i + 1) begin
                // Shift previous stage's bits forward
                adda_pipe[i] <= adda_pipe[i-1];
                addb_pipe[i] <= addb_pipe[i-1];
            end

            // Shift enable pipeline register
            en_pipe[0] <= i_en;
            for (i=1; i <= WIDTH; i = i +1) begin
                en_pipe[i] <= en_pipe[i-1];
            end

            // Register sum bits and carry bits at each stage from combinational outputs
            for (i = 0; i < WIDTH; i = i +1) begin
                sum_pipe[i] <= sum_out_vec[i];
                carry_pipe[i] <= carry_out_vec[i];
            end
            // Last carry bit
            carry_pipe[WIDTH] <= carry_out_vec[WIDTH-1];

            // Assemble output when pipeline is full and output enable asserted
            if (en_pipe[WIDTH]) begin
                // Concatenate sum bits (lowest bit at sum_pipe[0]) and final carry out
                // sum_pipe[] holds bitwise sums registered
                result <= {carry_pipe[WIDTH], 
                           sum_pipe[WIDTH-1], sum_pipe[WIDTH-2], sum_pipe[WIDTH-3], sum_pipe[WIDTH-4],
                           sum_pipe[WIDTH-5], sum_pipe[WIDTH-6], sum_pipe[WIDTH-7], sum_pipe[WIDTH-8],
                           sum_pipe[WIDTH-9], sum_pipe[WIDTH-10], sum_pipe[WIDTH-11], sum_pipe[WIDTH-12],
                           sum_pipe[WIDTH-13], sum_pipe[WIDTH-14], sum_pipe[WIDTH-15], sum_pipe[WIDTH-16],
                           sum_pipe[WIDTH-17], sum_pipe[WIDTH-18], sum_pipe[WIDTH-19], sum_pipe[WIDTH-20],
                           sum_pipe[WIDTH-21], sum_pipe[WIDTH-22], sum_pipe[WIDTH-23], sum_pipe[WIDTH-24],
                           sum_pipe[WIDTH-25], sum_pipe[WIDTH-26], sum_pipe[WIDTH-27], sum_pipe[WIDTH-28],
                           sum_pipe[WIDTH-29], sum_pipe[WIDTH-30], sum_pipe[WIDTH-31], sum_pipe[WIDTH-32],
                           sum_pipe[WIDTH-33], sum_pipe[WIDTH-34], sum_pipe[WIDTH-35], sum_pipe[WIDTH-36],
                           sum_pipe[WIDTH-37], sum_pipe[WIDTH-38], sum_pipe[WIDTH-39], sum_pipe[WIDTH-40],
                           sum_pipe[WIDTH-41], sum_pipe[WIDTH-42], sum_pipe[WIDTH-43], sum_pipe[WIDTH-44],
                           sum_pipe[WIDTH-45], sum_pipe[WIDTH-46], sum_pipe[WIDTH-47], sum_pipe[WIDTH-48],
                           sum_pipe[WIDTH-49], sum_pipe[WIDTH-50], sum_pipe[WIDTH-51], sum_pipe[WIDTH-52],
                           sum_pipe[WIDTH-53], sum_pipe[WIDTH-54], sum_pipe[WIDTH-55], sum_pipe[WIDTH-56],
                           sum_pipe[WIDTH-57], sum_pipe[WIDTH-58], sum_pipe[WIDTH-59], sum_pipe[WIDTH-60],
                           sum_pipe[WIDTH-61], sum_pipe[WIDTH-62], sum_pipe[WIDTH-63], sum_pipe[0]};
                // The concatenation order needs to build bits [64:0],
                // with bit 0 sum_pipe[0], bit 63 sum_pipe[63], MSB carry_pipe[64].
                // Because sum_pipe indexing is [0]=LSB stage 0, so to build result from MSB to LSB:
                // bits 63 downto 0 = sum_pipe[63:0], MSB = carry_pipe[64].
                // To correctly concatenate all bits in order, use a loop or packed vector

            end else begin
                result <= 0;
            end

            // Output enable pipeline
            o_en <= en_pipe[WIDTH];
        end
    end

    // To simplify concatenation, use a function to convert sum_pipe array to vector
    // But since Verilog does not support array to vector directly, we create a helper packed reg

    // Use continuous assignment to form a vector of sums, driven by sum_pipe regs
    wire [WIDTH-1:0] sum_vector;

    generate
        genvar idx;
        for (idx=0; idx < WIDTH; idx=idx+1) begin : sum_vector_gen
            assign sum_vector[idx] = sum_pipe[idx];
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // clear done already
        end else if (en_pipe[WIDTH]) begin
            // assign result with concatenation: carry_pipe[WIDTH] as MSB, then sum_vector[63:0]
            // sum_vector is arranged [63:0], LSB sum_vector[0]
            result <= {carry_pipe[WIDTH], sum_vector};
        end
    end

endmodule