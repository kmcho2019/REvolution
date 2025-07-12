module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output        done
);

    // States
    localparam IDLE = 1'b0;
    localparam RECV = 1'b1;

    reg state, next_state;
    reg [1:0] byte_count; // counts 0,1,2 for bytes received

    // Shift register to hold last 3 bytes
    reg [23:0] byte_shift;

    // Next state logic and byte_count update
    always @(*) begin
        next_state = state;
        // Default no change in count
        case(state)
            IDLE: begin
                if (in[3])
                    next_state = RECV;
            end
            RECV: begin
                if (byte_count == 2'd2)
                    next_state = IDLE;
            end
        endcase
    end

    // Sequential logic: state, byte_count, byte_shift update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte_count <= 2'd0;
            byte_shift <= 24'd0;
            out_bytes <= 24'd0;
        end else begin
            state <= next_state;
            if (state == IDLE) begin
                if (in[3]) begin
                    // First byte, load into highest byte position
                    byte_shift <= {in, 16'd0};
                    byte_count <= 2'd0;
                    // out_bytes will update after this cycle below
                end
            end else if (state == RECV) begin
                byte_count <= byte_count + 2'd1;
                // Shift in new byte from input on each cycle
                byte_shift <= {byte_shift[15:0], in};
            end
            // Output latch
            // out_bytes updates every cycle in RECV and on first sync byte
            if (state == RECV || (state == IDLE && in[3])) begin
                out_bytes <= byte_shift;
            end
        end
    end

    // done is asserted combinationally when three bytes have been received
    assign done = (state == RECV) && (byte_count == 2'd2);

endmodule