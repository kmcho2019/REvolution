module multi_pipe_4bit (
    input clk,  // clock signal
    input rst_n,  // active-low reset signal
    input [3:0] mul_a,  // input signal representing the multiplicand
    input [3:0] mul_b,  // input signal representing the multiplier
    output reg [7:0] mul_out  // product output signal
);

// define the size of the multiplier and multiplicand
parameter size = 4;

// define the number of processing elements (PEs) in the systolic array
parameter num_pes = size;

// define the width of the data path
parameter data_width = 8;

// declare the registers for the PEs
reg [data_width-1:0] pe_reg1 [num_pes-1:0];
reg [data_width-1:0] pe_reg2 [num_pes-1:0];

// declare the wires for the connections between PEs
wire [data_width-1:0] pe_wire [num_pes-1:0];

// generate the systolic array
genvar i;
generate
    for (i = 0; i < num_pes; i++) begin
        // instantiate the PEs
        if (i == 0) begin
            // first PE: multiply and add
            assign pe_wire[i] = (mul_b[i] == 1'b1)? {4'b0, mul_a} : 8'd0;
        end else begin
            // subsequent PEs: add
            assign pe_wire[i] = (mul_b[i] == 1'b1)? ({4'b0, mul_a} << i) : 8'd0;
        end
    end
endgenerate

// declare intermediate registers
reg [data_width-1:0] reg1;
reg [data_width-1:0] reg2;

// update the PE registers and output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // reset the PE registers and output
        reg1 <= 8'd0;
        reg2 <= 8'd0;
        mul_out <= 8'd0;
    end else begin
        // update the intermediate registers
        reg1 <= pe_wire[0];
        for (int i = 1; i < num_pes; i++) begin
            reg1 <= reg1 + pe_wire[i];
        end
        reg2 <= reg1;
        // update the output
        mul_out <= reg2;
    end
end

endmodule