module TopModule (
    input         clk,
    input         reset,
    input  [7:0]  in,
    output reg [23:0] out_bytes,
    output reg        done
);

    // One-hot FSM states
    localparam IDLE  = 4'b0001;
    localparam BYTE1 = 4'b0010;
    localparam BYTE2 = 4'b0100;
    localparam BYTE3 = 4'b1000;

    reg [3:0] state, next_state;

    // next_state logic combinational
    always @(*) begin
        next_state = state; // default hold
        case (state)
            IDLE:  next_state = (in[3]) ? BYTE1 : IDLE;
            BYTE1: next_state = BYTE2;
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic and datapath
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            out_bytes <= 24'b0;
            done      <= 1'b0;
        end else begin
            state <= next_state;
            done  <= 1'b0;

            case (next_state)
                BYTE1: begin
                    // First byte matched: store as most significant byte
                    out_bytes[23:16] <= in;
                end
                BYTE2: begin
                    // Shift in second byte
                    out_bytes[15:8] <= in;
                end
                BYTE3: begin
                    // Shift in third byte
                    out_bytes[7:0] <= in;
                end
                IDLE: begin
                    // Assert done when returning to IDLE after BYTE3
                    if (state == BYTE3)
                        done <= 1'b1;
                end
            endcase
        end
    end

endmodule