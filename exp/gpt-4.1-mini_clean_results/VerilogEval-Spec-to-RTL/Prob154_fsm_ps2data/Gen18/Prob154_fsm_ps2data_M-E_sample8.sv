module TopModule (
    input         clk,
    input         reset,
    input  [7:0]  in,
    output reg [23:0] out_bytes,
    output reg       done
);

    // FSM states encoding
    localparam IDLE  = 2'd0;
    localparam BYTE1 = 2'd1;
    localparam BYTE2 = 2'd2;
    localparam BYTE3 = 2'd3;

    reg [1:0] state, next_state;

    // FSM state register
    always @(posedge clk) begin
        if (reset) 
            state <= IDLE;
        else 
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case(state)
            IDLE:  next_state = (in[3]) ? BYTE1 : IDLE;
            BYTE1: next_state = BYTE2;
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Shift register datapath and done generation
    // Shift in new byte when in BYTE1, BYTE2, BYTE3 states
    always @(posedge clk) begin
        if (reset) begin
            out_bytes <= 24'b0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // default no done
            
            if (state == BYTE1 || state == BYTE2 || state == BYTE3) begin
                // Shift left by 8 bits and insert new byte at LSB
                out_bytes <= {out_bytes[15:0], in};
            end

            // Assert done after receiving BYTE3 byte
            if (state == BYTE3)
                done <= 1'b1;
        end
    end

endmodule