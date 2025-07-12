module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // One-hot state encoding
    localparam IDLE    = 2'b01;
    localparam ACTIVE  = 2'b10;
    
    reg [1:0] state, next_state;
    reg [3:0] bit_counter;  // Counts 0-9 (start + 8 data + stop)
    reg [7:0] data_reg;
    
    // Combinational done signal (asserts when valid stop bit detected)
    always @(*) begin
        done = (state == ACTIVE) && (bit_counter == 4'd9) && (in == 1'b1);
    end
    
    // State transition and data processing
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_counter <= 4'd0;
            data_reg <= 8'd0;
            out_byte <= 8'd0;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    bit_counter <= 4'd0;
                    if (in == 1'b0) begin
                        // Start bit detected
                        bit_counter <= 4'd1;
                    end
                end
                
                ACTIVE: begin
                    if (bit_counter < 4'd9) begin
                        bit_counter <= bit_counter + 1;
                        
                        // Capture data bits (positions 1-8)
                        if ((bit_counter >= 4'd1) && (bit_counter <= 4'd8)) begin
                            data_reg[bit_counter-1] <= in;  // Direct bit assignment
                        end
                    end
                    
                    // Update output when stop bit is valid
                    if (done) begin
                        out_byte <= data_reg;
                    end
                end
            endcase
        end
    end
    
    // Next state logic
    always @(*) begin
        case (state)
            IDLE: 
                next_state = (in == 1'b0) ? ACTIVE : IDLE;
                
            ACTIVE: begin
                if (bit_counter == 4'd9) begin
                    // After stop bit position, return to IDLE regardless of stop bit validity
                    next_state = IDLE;
                end else begin
                    next_state = ACTIVE;
                end
            end
            
            default: next_state = IDLE;
        endcase
    end

endmodule