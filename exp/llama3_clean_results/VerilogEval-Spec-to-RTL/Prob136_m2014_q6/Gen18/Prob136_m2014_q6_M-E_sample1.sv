module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states as parameters using one-hot encoding
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b011;
parameter D = 3'b010;
parameter E = 3'b110;
parameter F = 3'b111;

// Instantiate the distributed state machine modules
ModuleA module_a(
   .clk(clk),
   .reset(reset),
   .w(w),
   .z(z),
   .next_state_A(next_state_A),
   .next_state_B(next_state_B)
);

ModuleB module_b(
   .clk(clk),
   .reset(reset),
   .w(w),
   .next_state_A(next_state_A),
   .next_state_B(next_state_B),
   .next_state_C(next_state_C),
   .next_state_D(next_state_D)
);

ModuleC module_c(
   .clk(clk),
   .reset(reset),
   .w(w),
   .next_state_C(next_state_C),
   .next_state_D(next_state_D),
   .next_state_E(next_state_E),
   .next_state_F(next_state_F)
);

// Define the next-state logic for each module
reg [2:0] next_state_A;
reg [2:0] next_state_B;
reg [2:0] next_state_C;
reg [2:0] next_state_D;
reg [2:0] next_state_E;
reg [2:0] next_state_F;

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        next_state_A <= A;
        next_state_B <= B;
        next_state_C <= C;
        next_state_D <= D;
        next_state_E <= E;
        next_state_F <= F;
    end else begin
        next_state_A <= (w == 1'b0)? A : B;
        next_state_B <= (w == 1'b0)? C : D;
        next_state_C <= (w == 1'b0)? E : D;
        next_state_D <= (w == 1'b0)? F : A;
        next_state_E <= (w == 1'b0)? D : E;
        next_state_F <= (w == 1'b0)? D : C;
    end
end

endmodule

// Define the ModuleA
module ModuleA(
    input clk,
    input reset,
    input w,
    output reg z,
    output reg [2:0] next_state_A,
    output reg [2:0] next_state_B
);

// Define the state register and next-state logic for ModuleA
reg [2:0] current_state_A;
reg [2:0] current_state_B;

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        current_state_A <= A;
        current_state_B <= B;
    end else begin
        current_state_A <= next_state_A;
        current_state_B <= next_state_B;
    end
end

// Define the output logic for ModuleA
assign z = (current_state_A == E) || (current_state_A == F);

endmodule

// Define the ModuleB
module ModuleB(
    input clk,
    input reset,
    input w,
    input [2:0] next_state_A,
    input [2:0] next_state_B,
    output reg [2:0] next_state_C,
    output reg [2:0] next_state_D
);

// Define the state register and next-state logic for ModuleB
reg [2:0] current_state_C;
reg [2:0] current_state_D;

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        current_state_C <= C;
        current_state_D <= D;
    end else begin
        current_state_C <= next_state_C;
        current_state_D <= next_state_D;
    end
end

endmodule

// Define the ModuleC
module ModuleC(
    input clk,
    input reset,
    input w,
    input [2:0] next_state_C,
    input [2:0] next_state_D,
    output reg [2:0] next_state_E,
    output reg [2:0] next_state_F
);

// Define the state register and next-state logic for ModuleC
reg [2:0] current_state_E;
reg [2:0] current_state_F;

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        current_state_E <= E;
        current_state_F <= F;
    end else begin
        current_state_E <= next_state_E;
        current_state_F <= next_state_F;
    end
end

endmodule