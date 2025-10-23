module pulse_detect #(
    parameter USE_REGISTERED_OUTPUT = 1  // Enable registered output for better timing
)(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// One-hot state encoding
localparam IDLE   = 3'b001;
localparam GOT_0  = 3'b010;
localparam GOT_01 = 3'b100;

reg [2:0] state, next_state;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        if (USE_REGISTERED_OUTPUT) data_out <= 1'b0;
    end else begin
        state <= next_state;
        if (USE_REGISTERED_OUTPUT) begin
            data_out <= (state == GOT_01) && (data_in == 0);
        end
    end
end

// Next state logic - simplified with one-hot
always @(*) begin
    next_state = state; // Default to current state
    
    case (1'b1) // Synthesis will optimize this to parallel case
        state[0]: next_state = (data_in == 0) ? GOT_0 : IDLE;
        state[1]: next_state = (data_in == 1) ? GOT_01 : GOT_0;
        state[2]: next_state = (data_in == 0) ? IDLE : GOT_01;
    endcase
end

// Output logic - combinational if not registered
generate if (!USE_REGISTERED_OUTPUT) begin
    assign data_out = (state == GOT_01) && (data_in == 0);
end endgenerate

endmodule