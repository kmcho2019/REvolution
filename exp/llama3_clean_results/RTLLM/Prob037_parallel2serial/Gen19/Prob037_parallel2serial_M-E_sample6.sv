module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

// State encoding
enum logic [1:0] {
    IDLE = 2'b00,
    INIT = 2'b01,
    SHIFT = 2'b10,
    VALID = 2'b11
} state, next_state;

// Data and state register
reg [5:0] data_state;

// Combinational logic for next state and output
always_comb begin
    next_state = state;
    valid_out = 1'b0;
    dout = 1'b0;
    
    case (state)
        IDLE: begin
            if (d!= 4'b0000) begin
                next_state = INIT;
            end
        end
        INIT: begin
            next_state = SHIFT;
            valid_out = 1'b1;
            dout = d[3];
        end
        SHIFT: begin
            next_state = VALID;
            valid_out = 1'b1;
            dout = d[2];
        end
        VALID: begin
            next_state = IDLE;
            valid_out = 1'b1;
            dout = d[1];
        end
        default: ;
    endcase
end

// Sequential logic for state and data register
always_ff @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        data_state <= 6'b000000;
    end else begin
        case (next_state)
            IDLE: data_state <= {2'b00, d};
            INIT: data_state <= {2'b01, d};
            SHIFT: data_state <= {2'b10, d};
            VALID: data_state <= {2'b11, d};
            default: ;
        endcase
    end
end

// Current state and data
assign state = data_state[5:4];
assign d = data_state[3:0];

endmodule