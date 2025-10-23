module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    // One-hot encoded states for minimal switching and fast timing
    localparam IDLE  = 3'b001;
    localparam BYTE2 = 3'b010;
    localparam BYTE3 = 3'b100;

    reg [2:0] state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
        end else begin
            state <= next_state;
            // Assert done one cycle immediately after receiving third byte (BYTE3)
            done <= (state == BYTE3);
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                // Wait for start byte with in[3] == 1
                if (in[3])
                    next_state = BYTE2;
                else
                    next_state = IDLE;
            end
            BYTE2: begin
                next_state = BYTE3; // Accept any byte as second byte
            end
            BYTE3: begin
                next_state = IDLE;  // After third byte, return to idle
            end
            default: next_state = IDLE;
        endcase
    end

endmodule