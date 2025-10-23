// Module for state A
module StateA(
    input w,
    output reg Y1,
    output reg Y2,
    output reg Y3,
    output reg Y4
);

always @(*) begin
    if (w == 0) begin
        {Y1, Y2, Y3, Y4} = 4'b0_1_0_0; // B
    end else begin
        {Y1, Y2, Y3, Y4} = 4'b1_0_0_0; // A
    end
end

endmodule

// Module for state B
module StateB(
    input w,
    output reg Y1,
    output reg Y2,
    output reg Y3,
    output reg Y4
);

always @(*) begin
    if (w == 0) begin
        {Y1, Y2, Y3, Y4} = 4'b0_0_1_0; // C
    end else begin
        {Y1, Y2, Y3, Y4} = 4'b0_0_0_1; // D
    end
end

endmodule

// Module for state C
module StateC(
    input w,
    output reg Y1,
    output reg Y2,
    output reg Y3,
    output reg Y4
);

always @(*) begin
    if (w == 0) begin
        {Y1, Y2, Y3, Y4} = 4'b0_0_0_0; // E
    end else begin
        {Y1, Y2, Y3, Y4} = 4'b0_0_0_1; // D
    end
end

endmodule

// Module for state D
module StateD(
    input w,
    output reg Y1,
    output reg Y2,
    output reg Y3,
    output reg Y4
);

always @(*) begin
    if (w == 0) begin
        {Y1, Y2, Y3, Y4} = 4'b0_0_0_0; // F
    end else begin
        {Y1, Y2, Y3, Y4} = 4'b1_0_0_0; // A
    end
end

endmodule

// Module for state E
module StateE(
    input w,
    output reg Y1,
    output reg Y2,
    output reg Y3,
    output reg Y4
);

always @(*) begin
    if (w == 0) begin
        {Y1, Y2, Y3, Y4} = 4'b0_0_0_0; // E
    end else begin
        {Y1, Y2, Y3, Y4} = 4'b0_0_0_1; // D
    end
end

endmodule

// Module for state F
module StateF(
    input w,
    output reg Y1,
    output reg Y2,
    output reg Y3,
    output reg Y4
);

always @(*) begin
    if (w == 0) begin
        {Y1, Y2, Y3, Y4} = 4'b0_0_1_0; // C
    end else begin
        {Y1, Y2, Y3, Y4} = 4'b0_0_0_1; // D
    end
end

endmodule

// Top-level module
module TopModule(
    input [5:0] y,
    input w,
    output reg Y1,
    output reg Y3
);

wire [3:0] stateA_Y;
wire [3:0] stateB_Y;
wire [3:0] stateC_Y;
wire [3:0] stateD_Y;
wire [3:0] stateE_Y;
wire [3:0] stateF_Y;

StateA stateA_inst(.w(w), .Y1(stateA_Y[0]), .Y2(stateA_Y[1]), .Y3(stateA_Y[2]), .Y4(stateA_Y[3]));
StateB stateB_inst(.w(w), .Y1(stateB_Y[0]), .Y2(stateB_Y[1]), .Y3(stateB_Y[2]), .Y4(stateB_Y[3]));
StateC stateC_inst(.w(w), .Y1(stateC_Y[0]), .Y2(stateC_Y[1]), .Y3(stateC_Y[2]), .Y4(stateC_Y[3]));
StateD stateD_inst(.w(w), .Y1(stateD_Y[0]), .Y2(stateD_Y[1]), .Y3(stateD_Y[2]), .Y4(stateD_Y[3]));
StateE stateE_inst(.w(w), .Y1(stateE_Y[0]), .Y2(stateE_Y[1]), .Y3(stateE_Y[2]), .Y4(stateE_Y[3]));
StateF stateF_inst(.w(w), .Y1(stateF_Y[0]), .Y2(stateF_Y[1]), .Y3(stateF_Y[2]), .Y4(stateF_Y[3]));

always @(*) begin
    if (y == 6'b000001) begin
        {Y1, Y3} = {stateA_Y[0], stateA_Y[2]};
    end else if (y == 6'b000010) begin
        {Y1, Y3} = {stateB_Y[0], stateB_Y[2]};
    end else if (y == 6'b000100) begin
        {Y1, Y3} = {stateC_Y[0], stateC_Y[2]};
    end else if (y == 6'b001000) begin
        {Y1, Y3} = {stateD_Y[0], stateD_Y[2]};
    end else if (y == 6'b010000) begin
        {Y1, Y3} = {stateE_Y[0], stateE_Y[2]};
    end else if (y == 6'b100000) begin
        {Y1, Y3} = {stateF_Y[0], stateF_Y[2]};
    end
end

endmodule