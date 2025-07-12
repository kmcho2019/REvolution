module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // One-hot encoded states
    localparam IDLE  = 3'b001;
    localparam BYTE2 = 3'b010;
    localparam BYTE3 = 3'b100;
    
    reg [2:0] state, next_state;
    reg [23:0] msg_buffer;
    reg [1:0] byte_ptr;
    reg capture_byte;

    // FSM state transition
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            msg_buffer <= 24'b0;
            done <= 0;
            byte_ptr <= 0;
        end else begin
            state <= next_state;
            done <= (state == BYTE3);
            
            if (capture_byte) begin
                case (byte_ptr)
                    2'd0: msg_buffer[23:16] <= in;
                    2'd1: msg_buffer[15:8] <= in;
                    2'd2: msg_buffer[7:0] <= in;
                endcase
                byte_ptr <= byte_ptr + 1;
            end
        end
    end

    // FSM next state and capture logic
    always_comb begin
        next_state = state;
        capture_byte = 0;
        
        case (state)
            IDLE: begin
                if (in[3]) begin
                    next_state = BYTE2;
                    capture_byte = 1;
                end
            end
            BYTE2: begin
                next_state = BYTE3;
                capture_byte = 1;
            end
            BYTE3: begin
                next_state = IDLE;
                capture_byte = 1;
            end
        endcase
    end

    // Output only when done is asserted
    always_ff @(posedge clk) begin
        if (done) begin
            out_bytes <= msg_buffer;
        end
    end

endmodule