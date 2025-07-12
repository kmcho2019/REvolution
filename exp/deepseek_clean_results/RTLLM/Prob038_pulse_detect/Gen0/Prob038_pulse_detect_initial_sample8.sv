module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// State encoding
localparam IDLE  = 2'b00;
localparam GOT_0 = 2'b01;
localparam GOT_1 = 2'b10;

reg [1:0] state, next_state;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_out <= 1'b0;
    end
    else begin
        state <= next_state;
        
        // Output logic - pulse only when we complete the sequence
        if (state == GOT_1 && !data_in)
            data_out <= 1'b1;
        else
            data_out <= 1'b0;
    end
end

// Next state logic
always @(*) begin
    case (state)
        IDLE: begin
            if (!data_in)
                next_state = GOT_0;
            else
                next_state = IDLE;
        end
        
        GOT_0: begin
            if (data_in)
                next_state = GOT_1;
            else
                next_state = GOT_0;  // Stay here if we get consecutive 0s
        end
        
        GOT_1: begin
            if (!data_in)
                next_state = GOT_0;  // Start looking for new pulse
            else
                next_state = IDLE;   // If we get 1-1, reset
        end
        
        default: next_state = IDLE;
    endcase
end

endmodule