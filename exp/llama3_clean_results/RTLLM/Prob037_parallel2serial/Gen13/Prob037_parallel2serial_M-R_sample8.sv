module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

// Define states
localparam [1:0] IDLE = 2'b00;
localparam [1:0] MSB = 2'b01;
localparam [1:0] BIT2 = 2'b10;
localparam [1:0] BIT1 = 2'b11;

// State register
reg [1:0] state;

// Assign valid signal based on state
assign valid_out = (state != IDLE)? 1 : 0;

// Assign output based on state
always @(*) begin
    case (state)
        MSB: dout = d[3];
        BIT2: dout = d[2];
        BIT1: dout = d[1];
        default: dout = d[0]; // LSB
    endcase
end

// Next state logic
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
    end else begin
        case (state)
            IDLE: state <= MSB;
            MSB: state <= BIT2;
            BIT2: state <= BIT1;
            BIT1: state <= IDLE; // wrap around to IDLE after LSB
            default: state <= IDLE;
        endcase
    end
end

endmodule