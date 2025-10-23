module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output [23:0] out_bytes,
    output       done
);

    // State encoding
    localparam IDLE = 1'b0;
    localparam READ = 1'b1;

    reg state, next_state;
    reg [1:0] byte_count, next_byte_count;

    reg [7:0] byte0, byte1, byte2;
    reg done_reg, next_done_reg;

    // Sequential logic: state, byte_count, bytes, done_reg
    always @(posedge clk) begin
        if (reset) begin
            state      <= IDLE;
            byte_count <= 2'd0;
            byte0      <= 8'd0;
            byte1      <= 8'd0;
            byte2      <= 8'd0;
            done_reg   <= 1'b0;
        end else begin
            state      <= next_state;
            byte_count <= next_byte_count;
            byte0      <= (next_byte_count == 2'd0) ? byte0 : (next_byte_count == 2'd1 ? byte0 : byte0); // Hold byte0 unless updated below
            byte1      <= (next_byte_count == 2'd1) ? byte1 : (next_byte_count == 2'd2 ? byte1 : byte1); // Hold byte1 unless updated below
            byte2      <= (next_byte_count == 2'd2) ? byte2 : byte2; // Hold byte2 unless updated below
            done_reg   <= next_done_reg;

            // Update bytes based on byte_count transitions
            case (next_state)
                IDLE: begin
                    // no byte update
                end
                READ: begin
                    if (byte_count == 2'd0 && in[3]) begin
                        byte0 <= in;    // first byte
                    end else if (byte_count == 2'd1) begin
                        byte1 <= in;    // second byte
                    end else if (byte_count == 2'd2) begin
                        byte2 <= in;    // third byte
                    end
                end
            endcase
        end
    end

    // Combinational logic: next_state, next_byte_count, next_done_reg
    always @(*) begin
        next_state     = state;
        next_byte_count= byte_count;
        next_done_reg  = 1'b0;

        case(state)
            IDLE: begin
                if (in[3]) begin
                    next_state      = READ;
                    next_byte_count = 2'd1; // After capturing first byte
                end else begin
                    next_state      = IDLE;
                    next_byte_count = 2'd0;
                end
            end

            READ: begin
                if (byte_count == 2'd1) begin
                    next_byte_count = 2'd2;
                end else if (byte_count == 2'd2) begin
                    next_done_reg   = 1'b1; // done after third byte
                    next_state      = IDLE;
                    next_byte_count = 2'd0;
                end else begin
                    // Should not happen, but keep state
                    next_byte_count = byte_count;
                end
            end
        endcase
    end

    assign out_bytes = {byte0, byte1, byte2};
    assign done      = done_reg;

endmodule