module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // States - binary encoded
    localparam IDLE  = 2'b00;
    localparam BYTE1 = 2'b01;
    localparam BYTE2 = 2'b10;

    reg [1:0] state, next_state;
    reg [23:0] byte_buffer;

    // State transition and data capture
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte_buffer <= 24'b0;
            done <= 0;
        end else begin
            state <= next_state;
            
            // Capture bytes based on state
            case (state)
                IDLE:  if (in[3]) byte_buffer[23:16] <= in;
                BYTE1: byte_buffer[15:8] <= in;
                BYTE2: byte_buffer[7:0] <= in;
            endcase
            
            // Done is asserted one cycle after third byte
            done <= (state == BYTE2);
        end
    end

    // Next state logic - simplified
    always @(*) begin
        case (state)
            IDLE:  next_state = in[3] ? BYTE1 : IDLE;
            BYTE1: next_state = BYTE2;
            BYTE2: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Output only when done is asserted
    always @(*) begin
        out_bytes = done ? byte_buffer : 24'bx;
    end

endmodule