module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// State definitions
localparam IDLE  = 2'b00;  // Initial state, waiting for first 0
localparam GOT_0 = 2'b01;  // Received first 0, waiting for 1
localparam GOT_1 = 2'b10;  // Received 1, waiting for final 0

reg [1:0] state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Active-low reset: initialize to IDLE and clear output
        state <= IDLE;
        data_out <= 0;
    end else begin
        // Default output is 0 unless we complete a pulse
        data_out <= 0;
        
        case (state)
            IDLE: begin
                // Wait for first 0 in sequence
                if (data_in == 0)
                    state <= GOT_0;
            end
            
            GOT_0: begin
                // Wait for rising edge (1)
                if (data_in == 1)
                    state <= GOT_1;
                else
                    state <= GOT_0;  // Stay if we get another 0
            end
            
            GOT_1: begin
                // Check for falling edge (0)
                if (data_in == 0) begin
                    state <= IDLE;   // Pulse complete
                    data_out <= 1;  // Output pulse for 1 cycle
                end else begin
                    state <= GOT_1;  // Stay if we get another 1
                end
            end
            
            default: state <= IDLE;  // Handle undefined states
        endcase
    end
end

endmodule