module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // One-hot encoded states
    localparam IDLE  = 3'b001;
    localparam BYTE1 = 3'b010;
    localparam BYTE2 = 3'b100;

    reg [2:0] state, next_state;
    reg [23:0] byte_buffer;
    reg buffer_update;

    // State transition and data capture
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte_buffer <= 24'b0;
            done <= 0;
            out_bytes <= 24'b0;
        end else begin
            state <= next_state;
            
            // Capture bytes only when needed
            if (buffer_update) begin
                byte_buffer <= {byte_buffer[15:0], in};
            end
            
            // Register output only when done
            if (state == BYTE2) begin
                out_bytes <= byte_buffer;
            end
            
            // Done is asserted one cycle after third byte
            done <= (state == BYTE2);
        end
    end

    // Next state logic and buffer control
    always @(*) begin
        buffer_update = 0;
        case (state)
            IDLE: begin
                next_state = in[3] ? BYTE1 : IDLE;
                buffer_update = in[3];
            end
            BYTE1: begin
                next_state = BYTE2;
                buffer_update = 1;
            end
            BYTE2: begin
                next_state = IDLE;
                buffer_update = 1;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule