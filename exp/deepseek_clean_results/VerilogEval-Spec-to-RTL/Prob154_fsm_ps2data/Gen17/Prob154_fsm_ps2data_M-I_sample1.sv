module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // One-hot encoded states
    parameter IDLE  = 3'b001;
    parameter BYTE1 = 3'b010;
    parameter BYTE2 = 3'b100;
    reg [2:0] state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            out_bytes <= 24'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= (next_state == IDLE) && (state == BYTE2); // Only set done when completing packet
            
            case (state)
                IDLE: begin
                    if (in[3]) begin
                        out_bytes <= {in, 16'b0}; // Shift in first byte
                    end
                end
                BYTE1: begin
                    out_bytes <= {out_bytes[23:16], in, 8'b0}; // Shift in second byte
                end
                BYTE2: begin
                    out_bytes <= {out_bytes[23:8], in}; // Shift in third byte
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:  next_state = (in[3]) ? BYTE1 : IDLE;
            BYTE1: next_state = BYTE2;
            BYTE2: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule