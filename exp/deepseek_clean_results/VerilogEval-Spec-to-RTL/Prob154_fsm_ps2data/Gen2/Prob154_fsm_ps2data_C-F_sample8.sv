module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // States - binary encoded for area efficiency
    localparam IDLE  = 2'b00;
    localparam BYTE1 = 2'b01;
    localparam BYTE2 = 2'b10;

    reg [1:0] state, next_state;
    reg [23:0] byte_buffer;
    reg buffer_update;

    // State transition and buffer control
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte_buffer <= 24'b0;
            done <= 0;
        end else begin
            state <= next_state;
            
            // Update buffer only when needed
            if (buffer_update) begin
                case (state)
                    IDLE:  byte_buffer[23:16] <= in;
                    BYTE1: byte_buffer[15:8] <= in;
                    BYTE2: byte_buffer[7:0] <= in;
                endcase
            end
            
            // Done is asserted one cycle after third byte
            done <= (state == BYTE2);
        end
    end

    // Next state and buffer control logic
    always @(*) begin
        // Default assignments
        next_state = state;
        buffer_update = 0;
        
        case (state)
            IDLE: begin
                if (in[3]) begin
                    next_state = BYTE1;
                    buffer_update = 1;
                end
            end
            BYTE1: begin
                next_state = BYTE2;
                buffer_update = 1;
            end
            BYTE2: begin
                next_state = IDLE;
                buffer_update = 1;
            end
        endcase
    end

    // Output only when done is asserted
    always @(*) begin
        out_bytes = done ? byte_buffer : 24'bx;
    end

endmodule