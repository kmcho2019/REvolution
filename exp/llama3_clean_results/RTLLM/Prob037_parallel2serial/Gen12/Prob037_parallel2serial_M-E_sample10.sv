module parallel2serial #(
    parameter WIDTH = 4
) (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [WIDTH-1:0] d,          // Parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

// Enum for states
enum logic [1:0] {IDLE, BIT0, BIT1, BIT2, BIT3} state, next_state;

// Assign valid signal based on state
assign valid_out = (state!= IDLE);

// Assign output based on state
always_comb begin
    case (state)
        IDLE: dout = 1'b0;
        BIT0: dout = d[WIDTH-1];
        BIT1: dout = d[WIDTH-2];
        BIT2: dout = d[WIDTH-3];
        BIT3: dout = d[WIDTH-4];
        default: dout = 1'b0;
    endcase
end

// State transition logic
always_comb begin
    case (state)
        IDLE: next_state = (rst_n)? BIT0 : IDLE;
        BIT0: next_state = (rst_n)? BIT1 : IDLE;
        BIT1: next_state = (rst_n)? BIT2 : IDLE;
        BIT2: next_state = (rst_n)? BIT3 : IDLE;
        BIT3: next_state = (rst_n)? IDLE : IDLE;
        default: next_state = IDLE;
    endcase
end

// State register
always_ff @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

endmodule