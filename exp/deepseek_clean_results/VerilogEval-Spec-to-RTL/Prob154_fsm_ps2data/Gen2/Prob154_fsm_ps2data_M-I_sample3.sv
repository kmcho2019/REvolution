module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // One-hot encoded FSM states
    localparam IDLE  = 3'b001;
    localparam BYTE2 = 3'b010;
    localparam BYTE3 = 3'b100;
    
    reg [2:0] state, next_state;
    reg [23:0] msg_buffer;
    reg [1:0] byte_cnt;

    // FSM state transition (registered)
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte_cnt <= 2'b0;
            done <= 1'b0;
            out_bytes <= 24'b0;
        end else begin
            state <= next_state;
            
            // Capture byte only when needed
            if (state == IDLE && in[3]) begin
                msg_buffer[23:16] <= in;
                byte_cnt <= 2'b1;
            end else if (state == BYTE2) begin
                msg_buffer[15:8] <= in;
                byte_cnt <= 2'b2;
            end else if (state == BYTE3) begin
                msg_buffer[7:0] <= in;
                byte_cnt <= 2'b0;
            end
            
            // Register outputs for better timing
            done <= (state == BYTE3);
            if (state == BYTE3) begin
                out_bytes <= msg_buffer;
            end
        end
    end

    // Simplified next state logic
    always_comb begin
        next_state = state; // Default stay in current state
        case (state)
            IDLE:  if (in[3]) next_state = BYTE2;
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule