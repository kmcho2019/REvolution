module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

// Define states
enum logic [2:0] {IDLE, OUTPUT_BIT_0, OUTPUT_BIT_1, OUTPUT_BIT_2, OUTPUT_BIT_3} state, next_state;

// Assign valid signal based on state
assign valid_out = (state == OUTPUT_BIT_0 || state == OUTPUT_BIT_1 || state == OUTPUT_BIT_2 || state == OUTPUT_BIT_3);

// Assign output bit based on state
always_comb begin
    case(state)
        OUTPUT_BIT_0: dout = d[3];
        OUTPUT_BIT_1: dout = d[2];
        OUTPUT_BIT_2: dout = d[1];
        OUTPUT_BIT_3: dout = d[0];
        default: dout = 1'b0;
    endcase
end

// State machine logic
always_ff @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
    end else begin
        case(state)
            IDLE: state <= OUTPUT_BIT_0;
            OUTPUT_BIT_0: state <= OUTPUT_BIT_1;
            OUTPUT_BIT_1: state <= OUTPUT_BIT_2;
            OUTPUT_BIT_2: state <= OUTPUT_BIT_3;
            OUTPUT_BIT_3: state <= IDLE;
            default: state <= IDLE;
        endcase
    end
end

endmodule