module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

// Define the number of pipeline stages
localparam PIPELINE_STAGES = 2;

// Define the width of the input operands
localparam WIDTH = 64;

// Define the width of the output result
localparam RESULT_WIDTH = WIDTH + 1;

// Define the counter width
localparam COUNTER_WIDTH = $clog2(PIPELINE_STAGES + 1);

// Define the register signals
reg [WIDTH-1:0] reg_adda [PIPELINE_STAGES:0];
reg [WIDTH-1:0] reg_addb [PIPELINE_STAGES:0];
reg [RESULT_WIDTH-1:0] reg_result [PIPELINE_STAGES:0];
reg [COUNTER_WIDTH-1:0] reg_counter;

// Define the wire signals
wire [WIDTH-1:0] adda_pipe [PIPELINE_STAGES:0];
wire [WIDTH-1:0] addb_pipe [PIPELINE_STAGES:0];
wire [RESULT_WIDTH-1:0] result_pipe [PIPELINE_STAGES:0];

// Assign the input operands to the first pipeline stage
assign adda_pipe[0] = adda;
assign addb_pipe[0] = addb;

// Instantiate the full adders for each pipeline stage
genvar i;
generate
    for (i = 0; i < PIPELINE_STAGES; i++) begin
        full_adder fa(
           .a(adda_pipe[i]),
           .b(addb_pipe[i]),
           .cin(1'b0),
           .s(result_pipe[i]),
           .cout()
        );
        
        // Assign the output of the full adder to the next pipeline stage
        assign adda_pipe[i+1] = result_pipe[i][WIDTH-1:0];
        assign addb_pipe[i+1] = {WIDTH{1'b0}};
    end
endgenerate

// Assign the output of the last pipeline stage to the result
assign result = {1'b0, adda_pipe[PIPELINE_STAGES]};

// Synchronize the input enable signal with the clock and reset
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_adda[0] <= {WIDTH{1'b0}};
        reg_addb[0] <= {WIDTH{1'b0}};
        reg_result[0] <= {RESULT_WIDTH{1'b0}};
        reg_counter <= {COUNTER_WIDTH{1'b0}};
    end else if (i_en) begin
        reg_adda[0] <= adda;
        reg_addb[0] <= addb;
        reg_result[0] <= {RESULT_WIDTH{1'b0}};
        reg_counter <= {COUNTER_WIDTH{1'b0}};
    end
end

// Propagate the signals through the pipeline stages
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (int i = 1; i <= PIPELINE_STAGES; i++) begin
            reg_adda[i] <= {WIDTH{1'b0}};
            reg_addb[i] <= {WIDTH{1'b0}};
            reg_result[i] <= {RESULT_WIDTH{1'b0}};
        end
    end else begin
        for (int i = 1; i <= PIPELINE_STAGES; i++) begin
            reg_adda[i] <= reg_adda[i-1];
            reg_addb[i] <= reg_addb[i-1];
            reg_result[i] <= result_pipe[i-1];
        end
    end
end

// Update the output enable signal
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        o_en <= 1'b0;
    end else if (reg_counter == PIPELINE_STAGES) begin
        o_en <= 1'b1;
    end else begin
        o_en <= 1'b0;
    end
end

// Update the counter
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_counter <= {COUNTER_WIDTH{1'b0}};
    end else if (i_en) begin
        reg_counter <= reg_counter + 1;
    end else if (reg_counter == PIPELINE_STAGES) begin
        reg_counter <= {COUNTER_WIDTH{1'b0}};
    end
end

endmodule

// Full adder module
module full_adder(
    input [63:0] a,
    input [63:0] b,
    input cin,
    output [64:0] s,
    output cout
);

// Define the wire signals
wire [63:0] sum;
wire carry;

// Instantiate the ripple carry adder
ripple_carry_adder rca(
   .a(a),
   .b(b),
   .cin(cin),
   .s(sum),
   .cout(carry)
);

// Assign the output
assign s = {carry, sum};
assign cout = carry;

endmodule

// Ripple carry adder module
module ripple_carry_adder(
    input [63:0] a,
    input [63:0] b,
    input cin,
    output [63:0] s,
    output cout
);

// Define the wire signals
wire [63:0] sum;
wire [63:0] carry;

// Instantiate the full adder for each bit
genvar i;
generate
    for (i = 0; i < 64; i++) begin
        full_adder_bit fab(
           .a(a[i]),
           .b(b[i]),
           .cin(i == 0? cin : carry[i-1]),
           .s(sum[i]),
           .cout(carry[i])
        );
    end
endgenerate

// Assign the output
assign s = sum;
assign cout = carry[63];

endmodule

// Full adder bit module
module full_adder_bit(
    input a,
    input b,
    input cin,
    output s,
    output cout
);

// Define the wire signals
wire sum;
wire carry;

// Assign the output
assign sum = a ^ b ^ cin;
assign carry = (a & b) | (a & cin) | (b & cin);

// Assign the output
assign s = sum;
assign cout = carry;

endmodule