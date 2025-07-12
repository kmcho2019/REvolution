module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH  = 6          // log2(DATA_WIDTH) = 6 for 64 bits
)(
    input  wire                 clk,
    input  wire                 rst_n,
    input  wire                 i_en,
    input  wire [DATA_WIDTH-1:0] adda,
    input  wire [DATA_WIDTH-1:0] addb,
    output reg  [DATA_WIDTH:0]  result,
    output reg                  o_en
);

    // Pipeline registers per stage for carry and sum bits
    reg carry_pipe   [0:DATA_WIDTH];             // carry_pipe[0] initial carry_in = 0
    reg sum_pipe     [0:DATA_WIDTH-1];           // sum bits per stage

    // Pipeline registers for operand bits
    reg adda_bit_pipe[0:DATA_WIDTH-1];
    reg addb_bit_pipe[0:DATA_WIDTH-1];

    // Pipeline register for input enable signal delayed through pipeline
    reg [DATA_WIDTH:0] en_pipe;

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            carry_pipe[0] <= 1'b0;
            for (i = 0; i < DATA_WIDTH; i = i + 1) begin
                adda_bit_pipe[i] <= 1'b0;
                addb_bit_pipe[i] <= 1'b0;
                sum_pipe[i]      <= 1'b0;
                carry_pipe[i+1]  <= 1'b0;
            end
            en_pipe <= {(DATA_WIDTH+1){1'b0}};
            result <= {(DATA_WIDTH+1){1'b0}};
            o_en <= 1'b0;
        end else begin
            // Shift enable pipeline
            en_pipe <= {en_pipe[DATA_WIDTH-1:0], i_en};

            // At stage 0, latch the input operand bits if i_en asserted
            if (i_en) begin
                for (i = 0; i < DATA_WIDTH; i = i + 1) begin
                    adda_bit_pipe[i] <= adda[i];
                    addb_bit_pipe[i] <= addb[i];
                end
                carry_pipe[0] <= 1'b0; // initial carry-in zero
            end else begin
                // Hold operand bits stable otherwise
                for (i = 0; i < DATA_WIDTH; i = i + 1) begin
                    adda_bit_pipe[i] <= adda_bit_pipe[i];
                    addb_bit_pipe[i] <= addb_bit_pipe[i];
                end
                carry_pipe[0] <= carry_pipe[0];
            end

            // Ripple carry pipeline: from bit 0 to bit DATA_WIDTH-1
            for (i = 0; i < DATA_WIDTH; i = i + 1) begin
                // Compute sum and carry-out
                sum_pipe[i] <= adda_bit_pipe[i] ^ addb_bit_pipe[i] ^ carry_pipe[i];
                carry_pipe[i+1] <= (adda_bit_pipe[i] & addb_bit_pipe[i]) |
                                   (adda_bit_pipe[i] & carry_pipe[i]) |
                                   (addb_bit_pipe[i] & carry_pipe[i]);
            end

            // When final stage completed, assemble result
            if (en_pipe[DATA_WIDTH]) begin
                reg [DATA_WIDTH-1:0] sum_vector;
                for (i = 0; i < DATA_WIDTH; i = i + 1) begin
                    sum_vector[i] = sum_pipe[i];
                end
                result <= {carry_pipe[DATA_WIDTH], sum_vector};
            end else begin
                result <= result; // Hold previous result
            end

            // Output enable follows enable pipeline delay
            o_en <= en_pipe[DATA_WIDTH];
        end
    end

endmodule