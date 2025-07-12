module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// One-hot state encoding (better for FPGAs)
localparam [2:0] 
    IDLE      = 3'b001,
    GOT_0     = 3'b010,
    GOT_1     = 3'b100;

reg [2:0] current_state, next_state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
        data_out <= 1'b0;
    end
    else begin
        current_state <= next_state;
        // Output is high when we detect the falling edge after 0->1
        data_out <= (current_state == GOT_1) && (data_in == 1'b0);
    end
end

always @(*) begin
    // Default assignments
    next_state = current_state;
    data_out = 1'b0;

    case (current_state)
        IDLE: begin
            if (!data_in) next_state = GOT_0;
        end
        GOT_0: begin
            if (data_in) next_state = GOT_1;
            else next_state = GOT_0;  // Stay if consecutive 0s
        end
        GOT_1: begin
            if (!data_in) next_state = IDLE;  // Pulse complete
            else next_state = IDLE;   // Reset if consecutive 1s
        end
        default: next_state = IDLE;
    endcase
end

endmodule