module TopModule (
    input         clk,
    input         reset,
    input  [7:0]  in,
    output reg [23:0] out_bytes,
    output reg       done
);

    // FSM states encoding
    localparam WAIT_SYNC = 2'd0;
    localparam BYTE2     = 2'd1;
    localparam BYTE3     = 2'd2;

    reg [1:0] state, next_state;
    reg [23:0] next_out_bytes;
    reg next_done;

    // Combinational next state and output logic
    always @(*) begin
        // Default hold values
        next_state     = state;
        next_out_bytes = out_bytes;
        next_done      = 1'b0;

        case (state)
            WAIT_SYNC: begin
                if (in[3]) begin
                    next_out_bytes = {in, 16'd0};  // first byte in [23:16]
                    next_state     = BYTE2;
                end
            end
            BYTE2: begin
                next_out_bytes = {out_bytes[23:16], in, 8'd0}; // second byte [15:8]
                next_state     = BYTE3;
            end
            BYTE3: begin
                next_out_bytes = {out_bytes[23:8], in};        // third byte [7:0]
                next_done      = 1'b1;
                next_state     = WAIT_SYNC;
            end
            default: next_state = WAIT_SYNC;
        endcase
    end

    // Sequential logic: state and outputs update
    always @(posedge clk) begin
        if (reset) begin
            state     <= WAIT_SYNC;
            out_bytes <= 24'd0;
            done      <= 1'b0;
        end else begin
            state     <= next_state;
            out_bytes <= next_out_bytes;
            done      <= next_done;
        end
    end

endmodule