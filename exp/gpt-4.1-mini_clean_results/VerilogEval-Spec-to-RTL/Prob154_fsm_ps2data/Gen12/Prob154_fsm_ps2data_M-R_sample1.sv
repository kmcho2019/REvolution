module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg       done
);

    // State encoding for clarity
    localparam IDLE     = 2'd0;
    localparam BYTE_1   = 2'd1;
    localparam BYTE_2   = 2'd2;

    reg [1:0] state, next_state;
    reg [23:0] next_out_bytes;
    reg next_done;

    // State register update
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            out_bytes <= 24'd0;
            done      <= 1'b0;
        end else begin
            state     <= next_state;
            out_bytes <= next_out_bytes;
            done      <= next_done;
        end
    end

    // Next state and output logic
    always @(*) begin
        // Default assignments to hold values
        next_state     = state;
        next_out_bytes = out_bytes;
        next_done      = 1'b0;

        case (state)
            IDLE: begin
                // Wait for first byte with in[3]=1 to start capturing message
                if (in[3]) begin
                    next_out_bytes = {in, 16'd0}; // store first byte in MSB
                    next_state     = BYTE_1;
                end
            end
            BYTE_1: begin
                // Capture second byte in middle byte position
                next_out_bytes = {out_bytes[23:16], in, 8'd0};
                next_state     = BYTE_2;
            end
            BYTE_2: begin
                // Capture third byte in LSB and assert done
                next_out_bytes = {out_bytes[23:8], in};
                next_done      = 1'b1;
                next_state     = IDLE;
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule