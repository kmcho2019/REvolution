module TopModule(
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output [1:0] state
);

reg [1:0] state_reg;

// Define the states (binary encoding for simplicity)
localparam IDLE = 2'b00;
localparam LOW = 2'b01;
localparam MIDDLE = 2'b10;
localparam HIGH = 2'b11;

// Combinational logic for next state calculation
wire [1:0] next_state;
assign next_state = (train_valid && train_taken) ? (state_reg == HIGH) ? HIGH : state_reg + 1 :
                     (train_valid && !train_taken) ? (state_reg == IDLE) ? IDLE : state_reg - 1 :
                     state_reg;

// Sequential logic for state update
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_reg <= LOW; // Asynchronous reset to the LOW state
    end else begin
        state_reg <= next_state;
    end
end

assign state = state_reg;

endmodule