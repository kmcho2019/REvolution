module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // One-hot state encoding
    localparam IDLE     = 3'b001;
    localparam FIRST    = 3'b010;
    localparam SECOND   = 3'b100;

    reg [2:0] state;
    reg [2:0] next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
            out_bytes <= 24'bx;
        end else begin
            state <= next_state;
            
            // Default assignments
            done <= 1'b0;
            
            // Only update registers when in relevant states
            case (state)
                IDLE: begin
                    if (in[3]) begin
                        out_bytes[23:16] <= in;  // Store first byte
                    end
                end
                FIRST: begin
                    out_bytes[15:8] <= in;       // Store second byte
                end
                SECOND: begin
                    out_bytes[7:0] <= in;         // Store third byte
                    done <= 1'b1;                 // Assert done
                end
            endcase
        end
    end

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            IDLE:   next_state = (in[3]) ? FIRST : IDLE;
            FIRST:  next_state = SECOND;
            SECOND: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule