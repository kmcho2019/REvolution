// Define a D flip-flop module with active high synchronous reset
module DFF( 
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q_reg;

always @(negedge clk) begin
    if (reset) begin
        q_reg <= 8'h34;
    end else begin
        q_reg <= d;
    end
end

assign q = q_reg;

endmodule

// Alternatively, using assign statement and negedge clk
module DFF_alt( 
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

assign q = (reset)? 8'h34 : (clk == 1'b0)? d : q;

endmodule

// However, it is more conventional and practical to separate reset logic 
// from the clock edge logic for DFFs
module DFF_alt2( 
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

always @(negedge clk or posedge reset) begin
    if (reset) begin
        q <= 8'h34;
    end else begin
        q <= d;
    end
end

endmodule

// TopModule instantiates a single DFF to create an 8-bit register
module TopModule( 
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

DFF_alt2 u_dff( 
   .clk(clk),
   .reset(reset),
   .d(d),
   .q(q)
);

endmodule