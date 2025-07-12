// Define a single-stage D flip-flop module with active high synchronous reset
module DFF(
    input clk,
    input reset,
    input d,
    output reg q
);

always @(negedge clk) begin
    if (reset) begin
        q <= 1'b0;
    end else begin
        q <= d;
    end
end

endmodule

// Define an 8-stage shift register using the DFF module
module ShiftRegister(
    input clk,
    input reset,
    input d,
    output [7:0] q
);

wire [6:0] q_int;

// Instantiate 8 stages of DFF
DFF u_dff_0(
    .clk(clk),
    .reset(reset),
    .d(d),
    .q(q[0])
);

generate
    for (genvar i = 1; i < 8; i++) begin
        DFF u_dff(
            .clk(clk),
            .reset(reset),
            .d(i == 1 ? (reset ? 4'h3 : q[0]) : q[i-1]),
            .q(q[i])
        );
    end
endgenerate

// Load reset value when reset is asserted
always @(posedge reset) begin
    q_int[6:0] <= 7'b00110100; // Reset value for stages 1-7
end

endmodule

// TopModule instantiates the 8-stage shift register
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

// Instantiate the 8-stage shift register
ShiftRegister u_shift_register(
    .clk(clk),
    .reset(reset),
    .d(d[0]),
    .q(q)
);

endmodule