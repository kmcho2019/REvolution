module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // Define states
    localparam IDLE = 2'b00;
    localparam BYTE2 = 2'b01;
    localparam BYTE3 = 2'b10;
    
    reg [1:0] state, next_state;
    reg [23:0] byte_buffer;
    
    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 0;
            out_bytes <= 24'b0;
            byte_buffer <= 24'b0;
        end else begin
            state <= next_state;
            
            // Default outputs
            done <= 0;
            
            case (state)
                IDLE: begin
                    if (in[3]) begin
                        byte_buffer[23:16] <= in;
                    end
                end
                
                BYTE2: begin
                    byte_buffer[15:8] <= in;
                end
                
                BYTE3: begin
                    byte_buffer[7:0] <= in;
                    out_bytes <= {byte_buffer[23:16], byte_buffer[15:8], in};
                    done <= 1;
                end
            endcase
        end
    end
    
    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (in[3]) begin
                    next_state = BYTE2;
                end else begin
                    next_state = IDLE;
                end
            end
            
            BYTE2: begin
                next_state = BYTE3;
            end
            
            BYTE3: begin
                next_state = IDLE;
            end
            
            default: next_state = IDLE;
        endcase
    end

endmodule