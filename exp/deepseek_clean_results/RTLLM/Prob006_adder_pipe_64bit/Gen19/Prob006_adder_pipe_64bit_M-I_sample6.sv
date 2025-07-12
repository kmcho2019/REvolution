module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Parameters matching testbench expectations
parameter DATA_WIDTH = 64;
parameter STG_WIDTH = 32;

// Pipeline registers
reg [DATA_WIDTH-1:0] a_pipe, b_pipe;
reg [STG_WIDTH:0] sum_lower;  // Includes carry out
reg en_pipe;
reg carry_mid;

// Computation wires
wire [STG_WIDTH:0] sum_lower_wire;
wire [STG_WIDTH:0] sum_upper_wire;

// Lower 32-bit addition (combinational)
assign sum_lower_wire = {1'b0, adda[STG_WIDTH-1:0]} + {1'b0, addb[STG_WIDTH-1:0]};

// Upper 32-bit addition (combinational)
assign sum_upper_wire = {1'b0, a_pipe[DATA_WIDTH-1:STG_WIDTH]} + 
                       {1'b0, b_pipe[DATA_WIDTH-1:STG_WIDTH]} + 
                       carry_mid;

// Pipeline processing
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Clear all registers
        a_pipe <= {DATA_WIDTH{1'b0}};
        b_pipe <= {DATA_WIDTH{1'b0}};
        sum_lower <= {(STG_WIDTH+1){1'b0}};
        en_pipe <= 1'b0;
        carry_mid <= 1'b0;
        result <= {(DATA_WIDTH+1){1'b0}};
        o_en <= 1'b0;
    end else begin
        // Stage 1: Register inputs and compute lower sum
        a_pipe <= adda;
        b_pipe <= addb;
        sum_lower <= sum_lower_wire;
        carry_mid <= sum_lower_wire[STG_WIDTH];
        en_pipe <= i_en;

        // Stage 2: Compute final result
        if (en_pipe) begin
            result <= {sum_upper_wire, sum_lower[STG_WIDTH-1:0]};
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule