module multi_pipe_4bit (
    input clk,  // clock signal
    input rst_n,  // active-low reset signal
    input [3:0] mul_a,  // input signal representing the multiplicand
    input [3:0] mul_b,  // input signal representing the multiplier
    output reg [7:0] mul_out  // product output signal
);

// define the size of the multiplier and multiplicand
parameter size = 4;

// define the number of stages in the pipeline
parameter num_stages = 2;

// declare the registers for the pipeline
reg [7:0] stage_reg [num_stages-1:0];

// declare the wires for the connections between stages
wire [7:0] stage_wire [num_stages-1:0];

// CSA stage
assign stage_wire[0] = (mul_b[0] == 1'b1) ? {4'b0, mul_a} : 8'd0;

// generate the pipeline
genvar i;
generate
    for (i = 1; i < num_stages; i++) begin
        // RCA stage
        assign stage_wire[i] = stage_reg[i-1] + ((mul_b[i] == 1'b1) ? {4'b0, mul_a} << i : 8'd0);
    end
endgenerate

// update the pipeline registers and output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // reset the pipeline registers and output
        for (int i = 0; i < num_stages; i++) begin
            stage_reg[i] <= 8'd0;
        end
        mul_out <= 8'd0;
    end else begin
        // update the pipeline registers
        for (int i = 0; i < num_stages-1; i++) begin
            stage_reg[i] <= stage_wire[i];
        end
        // update the output
        mul_out <= stage_wire[num_stages-1];
    end
end

endmodule