module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

// State encoding (documentation only)
// 2'b00: Strongly not-taken
// 2'b01: Weakly not-taken (reset state)
// 2'b10: Weakly taken
// 2'b11: Strongly taken

wire [1:0] next_state;

// Combinational next state logic
assign next_state = areset ? 2'b01 :  // Async reset
                   train_valid ? 
                   (train_taken ? (state >= 2'b11 ? 2'b11 : state + 1'b1) :
                                 (state <= 2'b00 ? 2'b00 : state - 1'b1)) :
                   state;  // Hold when not training

// Clock gating logic
wire clk_en = areset | train_valid;

// Sequential state register with clock gating
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01;
    end else if (clk_en) begin
        state <= next_state;
    end
end

endmodule