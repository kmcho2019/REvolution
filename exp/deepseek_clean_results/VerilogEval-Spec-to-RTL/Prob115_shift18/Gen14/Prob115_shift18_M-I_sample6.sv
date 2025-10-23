module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Clock gating logic
wire clk_en = load | ena;
wire gated_clk;
assign gated_clk = clk & clk_en;

// Stage 1: Direction selection
reg direction_stage;
always @(posedge clk) begin
    if (ena) direction_stage <= ~amount[1]; // 0=right, 1=left
end

// Stage 2: Amount selection and shift operation
wire [63:0] shifted_value;
assign shifted_value = direction_stage ? 
                      (amount[0] ? {q[55:0], 8'b0} : {q[62:0], 1'b0}) :  // Left shifts
                      (amount[0] ? { {8{q[63]}}, q[63:8] } : {q[63], q[63:1]}); // Right shifts

// Next state logic with pipeline
wire [63:0] next_q = load ? data : shifted_value;

// Register update with gated clock
always @(posedge gated_clk) begin
    if (clk_en) begin
        q <= next_q;
    end
end

endmodule