module TopModule(
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output [1:0] state
);

reg [1:0] state_reg; // Internal register to hold the counter value
assign state = state_reg; // Continuous assignment to output the counter value

// Define the states and their corresponding binary codes
localparam IDLE = 2'b00;
localparam ONE = 2'b01;
localparam TWO = 2'b10;
localparam THREE = 2'b11;

// Combinational logic to calculate the next state
wire [1:0] next_state;
assign next_state = (areset) ? ONE : 
                    (train_valid) ? (train_taken) ? (state_reg == THREE) ? THREE : (state_reg == TWO) ? THREE : (state_reg == ONE) ? TWO : TWO :
                                              (state_reg == ONE) ? IDLE : (state_reg == TWO) ? ONE : (state_reg == THREE) ? TWO : IDLE :
                    state_reg;

// Sequential logic to update the state register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_reg <= ONE; // Asynchronous reset
    end else begin
        state_reg <= next_state;
    end
end

endmodule