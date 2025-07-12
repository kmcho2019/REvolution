module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

// States encoding
localparam IDLE      = 2'd0;
localparam DATA      = 2'd1;
localparam STOP_WAIT = 2'd2;

reg [1:0] state, next_state;
reg [2:0] bit_count; // counts 0 to 7 for 8 data bits

// Sequential state transition and output logic
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        bit_count <= 3'd0;
        done <= 1'b0;
    end else begin
        state <= next_state;
        done <= 1'b0; // default done low; asserted only for one cycle below
        case (state)
            IDLE: begin
                bit_count <= 3'd0;
                // done already cleared above
            end
            DATA: begin
                bit_count <= bit_count + 3'd1;
            end
            STOP_WAIT: begin
                // hold bit_count unchanged
            end
        endcase
    end
end

// Combinational next state and done output logic
always @(*) begin
    next_state = state;
    done = 1'b0;
    case(state)
        IDLE: begin
            if (in == 1'b0) // detect start bit
                next_state = DATA;
        end
        DATA: begin
            if (bit_count == 3'd7) begin
                // After last data bit, next bit is stop bit
                // stop bit check happens on next cycle
                next_state = (in == 1'b1) ? IDLE : STOP_WAIT;
                if (in == 1'b1) 
                    done = 1'b1;
            end
        end
        STOP_WAIT: begin
            if (in == 1'b1)
                next_state = IDLE;
        end
    endcase
end

endmodule