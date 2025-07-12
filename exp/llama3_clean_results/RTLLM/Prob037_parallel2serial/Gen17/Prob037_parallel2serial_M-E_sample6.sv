module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

// Define FSM states
localparam [1:0] IDLE = 2'b00;
localparam [1:0] BIT3 = 2'b01;
localparam [1:0] BIT2 = 2'b10;
localparam [1:0] BIT1 = 2'b11;

// Internal registers
reg [1:0] state;                 // Current FSM state
reg [1:0] next_state;            // Next FSM state

// Assign valid signal based on FSM state
assign valid_out = (state == BIT3 || state == BIT2 || state == BIT1 || state == IDLE) ? 1 : 0;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset FSM state
        state <= IDLE;
    end else begin
        // Update FSM state
        state <= next_state;
    end
end

always @ (*) begin
    case (state)
        IDLE: begin
            next_state = BIT3;
            dout = d[3];
        end
        BIT3: begin
            next_state = BIT2;
            dout = d[2];
        end
        BIT2: begin
            next_state = BIT1;
            dout = d[1];
        end
        BIT1: begin
            next_state = IDLE;
            dout = d[0];
        end
        default: begin
            next_state = IDLE;
            dout = 1'b0;
        end
    endcase
end

endmodule