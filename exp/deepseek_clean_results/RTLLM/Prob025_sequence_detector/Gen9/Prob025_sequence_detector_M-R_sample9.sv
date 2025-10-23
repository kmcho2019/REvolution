module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output sequence_detected
);

// One-hot state encoding
localparam IDLE = 2'b01;
localparam WAIT_FOR_LAST_1 = 2'b10;

reg [1:0] state;
reg [2:0] shift_reg;

// Shift register update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 3'b0;
    end
    else begin
        shift_reg <= {shift_reg[1:0], data_in};
    end
end

// State transitions
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
    end
    else begin
        case (state)
            IDLE:
                state <= (shift_reg[1:0] == 2'b10 && data_in == 1'b0) ? WAIT_FOR_LAST_1 : IDLE;
            
            WAIT_FOR_LAST_1:
                state <= IDLE;
            
            default:
                state <= IDLE;
        endcase
    end
end

// Combinational output
assign sequence_detected = (state == WAIT_FOR_LAST_1) && data_in && (shift_reg == 3'b100);

endmodule