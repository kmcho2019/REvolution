module TopModule (
    input [99:0] in,
    output reg [99:0] out_both,
    output reg [99:0] out_any,
    output reg [99:0] out_different
);

    reg [6:0] counter;  // 7 bits to count 0-99
    reg prev_bit;
    reg current_bit;
    wire wrap_prev_bit;  // For circular difference calculation
    
    // State machine states
    typedef enum {IDLE, PROCESSING} state_t;
    state_t state;
    
    // Circular buffer connection
    assign wrap_prev_bit = (counter == 0) ? in[99] : prev_bit;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            state <= IDLE;
            out_both <= 0;
            out_any <= 0;
            out_different <= 0;
            prev_bit <= 0;
        end else begin
            case (state)
                IDLE: begin
                    counter <= 0;
                    prev_bit <= in[99];  // Initialize with last bit for wrap-around
                    state <= PROCESSING;
                end
                
                PROCESSING: begin
                    current_bit <= in[counter];
                    
                    // Compute outputs for current position
                    if (counter < 99) begin
                        out_both[counter] <= in[counter] & in[counter+1];
                    end else begin
                        out_both[99] <= 1'b0;  // Boundary condition
                    end
                    
                    if (counter > 0) begin
                        out_any[counter] <= in[counter] | in[counter-1];
                    end else begin
                        out_any[0] <= 1'b0;  // Boundary condition
                    end
                    
                    out_different[counter] <= in[counter] ^ wrap_prev_bit;
                    
                    // Update for next cycle
                    prev_bit <= current_bit;
                    if (counter == 99) begin
                        state <= IDLE;
                    end else begin
                        counter <= counter + 1;
                    end
                end
            endcase
        end
    end

endmodule