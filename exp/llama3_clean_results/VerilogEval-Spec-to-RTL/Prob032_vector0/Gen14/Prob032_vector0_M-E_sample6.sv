module TopModule(
    input  wire clk,
    input  wire [2:0] vec,
    output wire [2:0] outv,
    output wire o2,
    output wire o1,
    output wire o0
);

// Internal wires to hold the latched values
wire [2:0] latched_vec;

// D Flip-Flops to latch the input vector
DFF dff_2(clk, vec[2], latched_vec[2]);
DFF dff_1(clk, vec[1], latched_vec[1]);
DFF dff_0(clk, vec[0], latched_vec[0]);

// Assign the latched vector to the output vector
assign outv = latched_vec;

// Assign the individual bits from the latched vector
assign o2 = latched_vec[2];
assign o1 = latched_vec[1];
assign o0 = latched_vec[0];

endmodule

// A basic D Flip-Flop module
module DFF(
    input  wire clk,
    input  wire d,
    output wire q
);
    reg q_reg;
    initial q_reg = 0;
    
    always @(posedge clk) begin
        q_reg <= d;
    end
    
    assign q = q_reg;
endmodule