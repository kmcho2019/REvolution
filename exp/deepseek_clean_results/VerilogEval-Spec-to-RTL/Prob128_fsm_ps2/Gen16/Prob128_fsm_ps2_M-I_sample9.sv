module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    // One-hot state encoding
    localparam IDLE  = 3'b001;
    localparam BYTE1 = 3'b010;
    localparam BYTE2 = 3'b100;
    
    reg [2:0] state;
    reg next_done;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
        end else begin
            // Register done output
            done <= next_done;
            
            // State transitions only when needed
            case (state)
                IDLE: if (in[3]) state <= BYTE1;
                BYTE1: state <= BYTE2;
                BYTE2: begin
                    state <= IDLE;
                    next_done <= 1'b1;
                end
                default: state <= IDLE;
            endcase
            
            // Clear done unless we're completing a message
            if (state != BYTE2) next_done <= 1'b0;
        end
    end

endmodule