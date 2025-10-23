module TopModule (
    input         clk,
    input         reset,
    input  [7:0]  in,
    output reg [23:0] out_bytes,
    output reg        done
);

// One-hot state encoding for 3 states
localparam WAIT_SYNC = 3'b001;
localparam BYTE1     = 3'b010;
localparam BYTE2     = 3'b100;

reg [2:0] state, next_state;

reg [7:0] byte1_reg, byte2_reg, byte3_reg;

// Sequential logic: state, message bytes, done and out_bytes registers
always @(posedge clk) begin
    if (reset) begin
        state    <= WAIT_SYNC;
        byte1_reg <= 8'b0;
        byte2_reg <= 8'b0;
        byte3_reg <= 8'b0;
        out_bytes <= 24'b0;
        done      <= 1'b0;
    end else begin
        state <= next_state;
        done  <= 1'b0;  // Default done low unless set below

        case (state)
            WAIT_SYNC: begin
                if (in[3]) begin
                    byte1_reg <= in;
                end
            end
            BYTE1: begin
                byte2_reg <= in;
            end
            BYTE2: begin
                byte3_reg <= in;
                done <= 1'b1;
                // Update output on done cycle
                out_bytes <= {byte1_reg, byte2_reg, in};
            end
            default: begin
                // No action
            end
        endcase
    end
end

// Next state logic combinational
always @(*) begin
    next_state = state;
    case (state)
        WAIT_SYNC: if (in[3]) next_state = BYTE1;
        BYTE1:     next_state = BYTE2;
        BYTE2:     next_state = WAIT_SYNC;
    endcase
end

endmodule