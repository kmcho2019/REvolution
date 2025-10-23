module adder_pipe_64bit (
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  [64:0]  result,
    output          o_en
);

// Define the number of bits in each chunk
parameter CHUNK_WIDTH = 8;

// Define the number of chunks
parameter NUM_CHUNKS = 64 / CHUNK_WIDTH;

// Define the width of the result
parameter RESULT_WIDTH = 65;

// Define the width of the input enable signal
parameter I_EN_WIDTH = 1;

// Define the width of the output enable signal
parameter O_EN_WIDTH = 1;

// Define the number of pipeline stages
parameter NUM_STAGES = NUM_CHUNKS + 1;

// Define the registers to store the input data
reg [CHUNK_WIDTH-1:0] adda_reg [NUM_CHUNKS-1:0];
reg [CHUNK_WIDTH-1:0] addb_reg [NUM_CHUNKS-1:0];

// Define the registers to store the intermediate results
reg [CHUNK_WIDTH:0] result_reg [NUM_CHUNKS-1:0];

// Define the register to store the final result
reg [RESULT_WIDTH-1:0] final_result_reg;

// Define the register to store the output enable signal
reg [O_EN_WIDTH-1:0] o_en_reg;

// Define the wires to connect the pipeline stages
wire [CHUNK_WIDTH-1:0] adda_wire [NUM_CHUNKS-1:0];
wire [CHUNK_WIDTH-1:0] addb_wire [NUM_CHUNKS-1:0];
wire [CHUNK_WIDTH:0] result_wire [NUM_CHUNKS-1:0];

// Define the carry-lookahead adder (CLA) modules
CLA #(.WIDTH(CHUNK_WIDTH)) claa [NUM_CHUNKS-1:0] (
    .a(adda_wire),
    .b(addb_wire),
    .cin(result_wire[0][CHUNK_WIDTH-1]),
    .cout(result_wire[0][CHUNK_WIDTH]),
    .sum(result_wire[0][CHUNK_WIDTH-1:0])
);

// Define the pipeline stages
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the registers
        for (int i = 0; i < NUM_CHUNKS; i++) begin
            adda_reg[i] <= 0;
            addb_reg[i] <= 0;
            result_reg[i] <= 0;
        end
        final_result_reg <= 0;
        o_en_reg <= 0;
    end else if (i_en) begin
        // Load the input data into the pipeline
        for (int i = 0; i < NUM_CHUNKS; i++) begin
            adda_reg[i] <= adda[(i*CHUNK_WIDTH)+CHUNK_WIDTH-1:(i*CHUNK_WIDTH)];
            addb_reg[i] <= addb[(i*CHUNK_WIDTH)+CHUNK_WIDTH-1:(i*CHUNK_WIDTH)];
        end

        // Propagate the results through the pipeline
        for (int i = 0; i < NUM_CHUNKS-1; i++) begin
            result_reg[i] <= result_wire[i];
        end

        // Store the final result
        final_result_reg <= {1'b0, result_wire[NUM_CHUNKS-1][CHUNK_WIDTH-1:0]};

        // Assert the output enable signal
        o_en_reg <= 1'b1;
    end else begin
        // Deassert the output enable signal
        o_en_reg <= 1'b0;
    end
end

// Define the output assignments
assign result = final_result_reg;
assign o_en = o_en_reg;

// Define the CLA module
module CLA (
    input [CHUNK_WIDTH-1:0] a,
    input [CHUNK_WIDTH-1:0] b,
    input cin,
    output cout,
    output [CHUNK_WIDTH-1:0] sum
);

// Define the wires to connect the CLA stages
wire [CHUNK_WIDTH-1:0] p;
wire [CHUNK_WIDTH-1:0] g;
wire [CHUNK_WIDTH-1:0] c;

// Define the CLA logic
always @ (*) begin
    // Calculate the propagate and generate signals
    for (int i = 0; i < CHUNK_WIDTH; i++) begin
        p[i] = a[i] ^ b[i];
        g[i] = a[i] & b[i];
    end

    // Calculate the carry signals
    c[0] = cin;
    for (int i = 1; i < CHUNK_WIDTH; i++) begin
        c[i] = g[i-1] | (p[i-1] & c[i-1]);
    end

    // Calculate the sum signals
    for (int i = 0; i < CHUNK_WIDTH; i++) begin
        sum[i] = a[i] ^ b[i] ^ c[i];
    end

    // Calculate the carry-out signal
    cout = g[CHUNK_WIDTH-1] | (p[CHUNK_WIDTH-1] & c[CHUNK_WIDTH-1]);
end

endmodule

endmodule