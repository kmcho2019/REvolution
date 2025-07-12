module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    // One-hot state encoding for better timing
    localparam IDLE  = 3'b001;
    localparam RECEIVE = 3'b010;
    localparam STOP = 3'b100;
    
    reg [2:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    wire receive_done = (bit_count == 3'd7);
    
    // Clock gating control
    wire shift_en = (state == RECEIVE);
    reg [7:0] shift_reg_ff;
    
    // State transition (registered)
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            done <= 0;
        end else begin
            state <= next_state;
            
            // Done signal generation (pipelined)
            done <= (state == STOP) && in;
            
            // Bit counter
            if (state == RECEIVE) begin
                bit_count <= bit_count + 1;
            end else begin
                bit_count <= 0;
            end
        end
    end
    
    // Shift register with clock gating
    always @(posedge clk) begin
        if (reset) begin
            shift_reg_ff <= 0;
        end else if (shift_en) begin
            shift_reg_ff <= {in, shift_reg_ff[7:1]}; // LSB first
        end
    end
    
    // Next state logic (combinational)
    always @(*) begin
        case (state)
            IDLE: next_state = in ? IDLE : RECEIVE;
            
            RECEIVE: next_state = receive_done ? STOP : RECEIVE;
            
            STOP: next_state = in ? IDLE : STOP;
            
            default: next_state = IDLE;
        endcase
    end
    
    // Output assignment
    assign shift_reg = shift_reg_ff;

endmodule