module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

// Define parameters for segmentation and pipelining
parameter DATA_WIDTH = 8;
parameter NUM_STAGES = 64 / DATA_WIDTH;
parameter PIPELINE_DEPTH = NUM_STAGES + 1;

// Define registers for pipeline stages
reg [DATA_WIDTH-1:0] stage_regs [0:NUM_STAGES-1];
reg [DATA_WIDTH-1:0] adda_regs [0:NUM_STAGES-1];
reg [DATA_WIDTH-1:0] addb_regs [0:NUM_STAGES-1];
reg [NUM_STAGES-1:0] carry_regs;

// Combinational logic for full adder array
wire [NUM_STAGES-1:0] sum_wires [0:NUM_STAGES-1];
wire [NUM_STAGES-1:0] carry_wires [0:NUM_STAGES-1];

genvar i;
generate
    for (i = 0; i < NUM_STAGES; i++) begin
        full_adder fa (
            .a(adda_regs[i]),
            .b(addb_regs[i]),
            .cin(carry_regs[i]),
            .sum(sum_wires[i]),
            .cout(carry_wires[i])
        );
    end
endgenerate

// Sequential logic for reset, input registration, and pipeline propagation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset pipeline stages and registers
        for (int i = 0; i < NUM_STAGES; i++) begin
            stage_regs[i] <= 0;
            adda_regs[i] <= 0;
            addb_regs[i] <= 0;
            carry_regs[i] <= 0;
        end
    end else begin
        // Register inputs and propagate pipeline
        for (int i = 0; i < NUM_STAGES; i++) begin
            if (i == 0) begin
                adda_regs[i] <= adda[DATA_WIDTH-1:0];
                addb_regs[i] <= addb[DATA_WIDTH-1:0];
            end else begin
                adda_regs[i] <= adda[(i*DATA_WIDTH)+DATA_WIDTH-1:(i*DATA_WIDTH)];
                addb_regs[i] <= addb[(i*DATA_WIDTH)+DATA_WIDTH-1:(i*DATA_WIDTH)];
            end
            stage_regs[i] <= sum_wires[i-1];
            carry_regs[i] <= carry_wires[i-1];
        end
    end
end

// Output logic for result and enable signal
assign result = {1'b0, stage_regs[NUM_STAGES-1]};
assign o_en = (carry_regs[NUM_STAGES-1] == 1'b1);

endmodule

// Full adder module for array
module full_adder(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);
    assign sum = a + b + cin;
    assign cout = (a + b + cin) > 8'd255;
endmodule