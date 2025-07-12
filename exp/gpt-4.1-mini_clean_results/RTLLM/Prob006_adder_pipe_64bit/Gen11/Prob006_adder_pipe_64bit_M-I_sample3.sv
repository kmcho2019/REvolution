module adder_pipe_64bit (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        i_en,
    input  wire [63:0] adda,
    input  wire [63:0] addb,
    output reg  [64:0] result,
    output reg         o_en
);

    localparam DEPTH = 65; // 64 bits + 1 carry out

    // Pipeline registers as vectors:
    // Each stage holds one bit of operands, sum bits collected in vector,
    // carries are shifted through a DEPTH-length shift register.

    reg [63:0] a_pipe;       // input A bits pipeline register (shifts right per stage)
    reg [63:0] b_pipe;       // input B bits pipeline register (shifts right per stage)
    reg [63:0] sum_pipe;     // store sum bits after computation per stage
    reg [DEPTH-1:0] carry_pipe; // carry chain shifted through pipeline stages
    reg [DEPTH-1:0] en_pipe;    // pipeline enable shift register

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_pipe    <= 64'b0;
            b_pipe    <= 64'b0;
            sum_pipe  <= 64'b0;
            carry_pipe<= {DEPTH{1'b0}};
            en_pipe   <= {DEPTH{1'b0}};
            result    <= 65'b0;
            o_en      <= 1'b0;
        end else begin
            // Shift enable pipeline register
            en_pipe <= {en_pipe[DEPTH-2:0], i_en};

            if (i_en) begin
                // Load new operand bits into LSB of pipeline registers
                a_pipe <= adda;
                b_pipe <= addb;
                carry_pipe[0] <= 1'b0; // initial carry-in
            end else begin
                // Hold operands (no new load), shift bits down per pipeline stage
                // Actually, operands advance stage by stage on every clock to simulate bitwise pipeline
                a_pipe <= {1'b0, a_pipe[63:1]}; // shift right by 1 bit, insert 0 MSB
                b_pipe <= {1'b0, b_pipe[63:1]};
                carry_pipe[0] <= carry_pipe[0]; // no change on carry in stage 0
            end

            // Compute sum bit and carry out for current LSB (stage 0)
            // sum = a0 ^ b0 ^ carry_in
            // carry_out = majority(a0,b0,carry_in)
            sum_pipe[0] <= a_pipe[0] ^ b_pipe[0] ^ carry_pipe[0];
            carry_pipe[1] <= (a_pipe[0] & b_pipe[0]) | (a_pipe[0] & carry_pipe[0]) | (b_pipe[0] & carry_pipe[0]);

            // Propagate sum bits and carry through pipeline stages 1..63
            // For each stage i (1..63):
            // sum_pipe[i] = a_pipe[i] ^ b_pipe[i] ^ carry_pipe[i]
            // carry_pipe[i+1] = majority(a_pipe[i], b_pipe[i], carry_pipe[i])

            for (i = 1; i < 64; i = i + 1) begin
                sum_pipe[i] <= a_pipe[i] ^ b_pipe[i] ^ carry_pipe[i];
                carry_pipe[i+1] <= (a_pipe[i] & b_pipe[i]) |
                                   (a_pipe[i] & carry_pipe[i]) |
                                   (b_pipe[i] & carry_pipe[i]);
            end

            // Output result and enable delayed by DEPTH cycles
            o_en <= en_pipe[DEPTH-1];

            if (en_pipe[DEPTH-1]) begin
                // assemble the final sum from sum bits and final carry
                result <= {carry_pipe[DEPTH-1], sum_pipe};
            end
        end
    end

endmodule