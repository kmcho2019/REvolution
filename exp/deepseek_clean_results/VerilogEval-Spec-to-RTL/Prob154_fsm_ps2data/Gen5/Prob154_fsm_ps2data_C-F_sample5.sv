module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // One-hot encoded states for better timing
    localparam IDLE  = 3'b001;
    localparam BYTE2 = 3'b010;
    localparam BYTE3 = 3'b100;
    
    reg [2:0] state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            out_bytes <= 24'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0;
            
            case (state)
                IDLE: begin
                    if (in[3]) begin
                        out_bytes <= {out_bytes[15:0], in};
                    end
                end
                BYTE2: begin
                    out_bytes <= {out_bytes[15:0], in};
                end
                BYTE3: begin
                    out_bytes <= {out_bytes[15:0], in};
                    done <= 1'b1;
                end
                default: state <= IDLE;
            endcase
        end
    end

    always @(*) begin
        case (state)
            IDLE:  next_state = in[3] ? BYTE2 : IDLE;
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Output remains don't-care when not done
    // No need for explicit combinational logic since out_bytes is registered

endmodule