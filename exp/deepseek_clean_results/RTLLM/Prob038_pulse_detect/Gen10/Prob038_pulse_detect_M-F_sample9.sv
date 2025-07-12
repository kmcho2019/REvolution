module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// State encoding with added WAIT state
localparam [1:0] IDLE   = 2'b00;
localparam [1:0] GOT_0  = 2'b01;
localparam [1:0] GOT_01 = 2'b10;
localparam [1:0] WAIT   = 2'b11;  // Added wait state for power optimization

reg [1:0] current_state, next_state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
        data_out <= 1'b0;
    end else begin
        current_state <= next_state;
        
        // Output is only high when we complete the sequence
        data_out <= (current_state == GOT_01) && (data_in == 1'b0);
    end
end

always @(*) begin
    case (current_state)
        IDLE: begin
            if (data_in == 1'b0)
                next_state = GOT_0;
            else
                next_state = IDLE;
        end
        GOT_0: begin
            if (data_in == 1'b1)
                next_state = GOT_01;
            else
                next_state = GOT_0;
        end
        GOT_01: begin
            if (data_in == 1'b0)
                next_state = WAIT;  // Go to WAIT instead of IDLE
            else
                next_state = GOT_01;
        end
        WAIT: begin
            // Stay in WAIT until input goes high before looking for next pulse
            next_state = (data_in == 1'b1) ? IDLE : WAIT;
        end
        default: next_state = IDLE;
    endcase
end

endmodule