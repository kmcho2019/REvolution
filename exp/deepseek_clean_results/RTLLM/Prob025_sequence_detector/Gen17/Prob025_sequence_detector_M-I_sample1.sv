module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

reg [2:0] shift_reg;  // Reduced to 3 bits
reg [1:0] state;      // Binary encoded states
wire update_reg;

// State encoding
localparam IDLE = 2'b00;
localparam S1   = 2'b01;  // '1'
localparam S2   = 2'b10;  // '10'
localparam S3   = 2'b11;  // '100'

// Clock gating condition - only update when needed
assign update_reg = (state != IDLE) || data_in;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 3'b0;
        state <= IDLE;
        sequence_detected <= 1'b0;
    end
    else if (update_reg) begin
        // State transitions
        case (state)
            IDLE: state <= data_in ? S1 : IDLE;
            S1:   state <= data_in ? S1 : S2;
            S2:   state <= data_in ? S1 : S3;
            S3:   state <= data_in ? S1 : IDLE;
        endcase

        // Shift register update
        shift_reg <= {shift_reg[1:0], data_in};

        // Output logic - detect '1001' (last 3 bits are '100' and current is '1')
        sequence_detected <= (state == S3) & data_in;
    end
    else begin
        sequence_detected <= 1'b0;
    end
end

endmodule