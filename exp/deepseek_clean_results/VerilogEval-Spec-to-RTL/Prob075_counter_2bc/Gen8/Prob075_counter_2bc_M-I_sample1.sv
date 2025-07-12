module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

// Parameters
localparam RESET_VALUE = 2'b01;  // Weakly not-taken

// Gray-coded state transitions
wire [1:0] next_state_gray;

// Clock gating
wire gated_clk = clk & (train_valid | areset);

// Arithmetic next state calculation
wire [1:0] next_state_bin;
assign next_state_bin = (train_taken) ? 
                       (state == 2'b11) ? state : (state + 1'b1) :
                       (state == 2'b00) ? state : (state - 1'b1);

// Convert binary to Gray code
assign next_state_gray = next_state_bin ^ {1'b0, next_state_bin[1]};

// State register with clock gating
always @(posedge gated_clk or posedge areset) begin
    if (areset)
        state <= RESET_VALUE;
    else if (train_valid)
        state <= next_state_gray;
    // Else: state holds its value (implicit through clock gating)
end

endmodule