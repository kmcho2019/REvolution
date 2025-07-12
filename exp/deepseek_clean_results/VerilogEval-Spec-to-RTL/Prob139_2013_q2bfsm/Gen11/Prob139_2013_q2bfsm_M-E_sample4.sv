module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// States
typedef enum {
    INIT,
    WAIT_FOR_SEQ,
    SEQ_DETECTED,
    FINAL
} state_t;

state_t current_state;
reg [1:0] seq_counter;
reg timeout_flag;
reg g_latch;

always @(posedge clk) begin
    if (!resetn) begin
        current_state <= INIT;
        f <= 1'b0;
        g <= 1'b0;
        seq_counter <= 2'b00;
        timeout_flag <= 1'b0;
        g_latch <= 1'b0;
    end else begin
        case (current_state)
            INIT: begin
                f <= 1'b1;
                g <= 1'b0;
                current_state <= WAIT_FOR_SEQ;
            end
            
            WAIT_FOR_SEQ: begin
                f <= 1'b0;
                
                // Sequence detection logic
                if (x) begin
                    if (seq_counter == 2'b01) begin
                        seq_counter <= 2'b10;  // Second '1' in sequence
                    end else if (seq_counter == 2'b00) begin
                        seq_counter <= 2'b01;  // First '1' in sequence
                    end
                end else if (seq_counter == 2'b01) begin
                    seq_counter <= 2'b11;      // '0' in middle of sequence
                end else begin
                    seq_counter <= 2'b00;      // Reset sequence counter
                end
                
                // Transition when full sequence detected
                if (seq_counter == 2'b10) begin
                    current_state <= SEQ_DETECTED;
                    g <= 1'b1;
                    g_latch <= 1'b1;
                    seq_counter <= 2'b00;
                end
            end
            
            SEQ_DETECTED: begin
                if (y) begin
                    current_state <= FINAL;
                end else if (!timeout_flag) begin
                    timeout_flag <= 1'b1;
                end else begin
                    g <= 1'b0;
                    g_latch <= 1'b0;
                    current_state <= FINAL;
                end
            end
            
            FINAL: begin
                // Maintain outputs until reset
                g <= g_latch;
            end
        endcase
    end
end

endmodule