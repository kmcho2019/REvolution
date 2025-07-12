module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output reg done
);

    // One-hot state encoding
    localparam IDLE  = 3'b001;
    localparam BYTE1 = 3'b010;
    localparam BYTE2 = 3'b100;

    reg [2:0] state, next_state;
    reg [7:0] byte1, byte2, byte3;

    // Continuous assignment for output
    assign out_bytes = done ? {byte1, byte2, byte3} : 24'bx;

    // State transition logic
    always @(*) begin
        case (state)
            IDLE:  next_state = in[3] ? BYTE1 : IDLE;
            BYTE1: next_state = BYTE2;
            BYTE2: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // State and data registers
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
        end else begin
            state <= next_state;
            
            // Default assignments
            done <= 1'b0;
            
            // Store bytes and set done
            case (next_state)
                BYTE1: byte1 <= in;
                BYTE2: byte2 <= in;
                IDLE: begin
                    if (state == BYTE2) begin
                        byte3 <= in;
                        done <= 1'b1;
                    end
                end
            endcase
        end
    end

endmodule