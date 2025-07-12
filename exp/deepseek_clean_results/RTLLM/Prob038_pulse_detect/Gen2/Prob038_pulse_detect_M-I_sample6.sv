module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// One-hot state encoding
localparam IDLE  = 3'b001;
localparam GOT_0 = 3'b010;
localparam GOT_1 = 3'b100;

reg [2:0] state, next_state;

// State transition logic
always @(*) begin
    next_state = state; // Default: stay in current state
    case (state)
        IDLE:  next_state = (data_in == 0) ? GOT_0 : IDLE;
        GOT_0: next_state = (data_in == 1) ? GOT_1 : GOT_0;
        GOT_1: next_state = (data_in == 0) ? IDLE  : GOT_1;
    endcase
end

// State register and output logic
always @(posedge clk) begin
    if (!rst_n) begin
        state <= IDLE;
        data_out <= 0;
    end else begin
        state <= next_state;
        // Output is high only when transitioning from GOT_1 to IDLE
        data_out <= (state == GOT_1) && (next_state == IDLE);
    end
end

endmodule