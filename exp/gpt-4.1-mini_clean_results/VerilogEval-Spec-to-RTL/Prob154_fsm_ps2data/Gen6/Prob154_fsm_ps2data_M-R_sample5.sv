module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // State encoding
    localparam IDLE  = 2'd0;
    localparam BYTE2 = 2'd1;
    localparam BYTE3 = 2'd2;

    reg [1:0] state, next_state;
    reg [23:0] msg_shift;

    // State and message registers update
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            msg_shift <= 24'd0;
            done      <= 1'b0;
            out_bytes <= 24'd0;
        end else begin
            state <= next_state;
            done  <= 1'b0; // default done low, will assert in next_state logic below
            case (state)
                IDLE: begin
                    // Waiting for start byte (in[3] == 1)
                    if (in[3]) begin
                        msg_shift <= {in, 16'd0};
                        // next_state logic below
                    end
                end
                BYTE2: begin
                    // Shift in second byte
                    msg_shift <= {msg_shift[15:0], in};
                end
                BYTE3: begin
                    // Shift in third byte and output done signal and bytes
                    msg_shift <= {msg_shift[15:0], in};
                    done      <= 1'b1;
                    out_bytes <= {msg_shift[15:0], in};
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state; // default stay
        case (state)
            IDLE: begin
                if (in[3])
                    next_state = BYTE2;
            end
            BYTE2: begin
                next_state = BYTE3;
            end
            BYTE3: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule