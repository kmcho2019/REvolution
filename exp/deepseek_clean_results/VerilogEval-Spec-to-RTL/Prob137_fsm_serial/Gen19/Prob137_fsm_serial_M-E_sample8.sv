module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    // Predictive states
    localparam IDLE      = 2'b00;
    localparam RECEIVING = 2'b01;
    localparam VALIDATE  = 2'b10;
    localparam RECOVER   = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_buffer;
    reg capture_en;
    reg early_stop_err;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            data_buffer <= 8'b0;
            done <= 1'b0;
            early_stop_err <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0;  // Default to 0, pulsed only when valid
            
            // Counter and early stop detection
            if (state == RECEIVING) begin
                bit_count <= bit_count + 1;
                // Check if current bit looks like premature stop
                if ((bit_count != 3'b111) && (in == 1'b1)) begin
                    early_stop_err <= 1'b1;
                end
            end else begin
                bit_count <= 3'b0;
                early_stop_err <= 1'b0;
            end
            
            // Parallel capture on last data bit
            if (capture_en) begin
                data_buffer <= {in, data_buffer[7:1]};  // Still LSB first
            end
            
            // Single-cycle done pulse
            if ((state == VALIDATE) && (in == 1'b1)) begin
                done <= 1'b1;
            end
        end
    end

    // Combinational next state logic
    always @(*) begin
        next_state = state;
        capture_en = 1'b0;
        
        case (state)
            IDLE: begin
                if (in == 1'b0) begin
                    next_state = RECEIVING;
                end
            end
            
            RECEIVING: begin
                if (bit_count == 3'b111) begin
                    capture_en = 1'b1;
                    next_state = VALIDATE;
                end else if (early_stop_err) begin
                    next_state = RECOVER;
                end
            end
            
            VALIDATE: begin
                if (in == 1'b1) begin
                    next_state = IDLE;
                end else begin
                    next_state = RECOVER;
                end
            end
            
            RECOVER: begin
                if (in == 1'b1) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

endmodule