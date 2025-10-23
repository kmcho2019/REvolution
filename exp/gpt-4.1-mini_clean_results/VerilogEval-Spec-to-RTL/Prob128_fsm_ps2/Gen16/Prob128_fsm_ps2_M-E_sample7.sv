module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    typedef enum logic [0:0] {
        IDLE = 1'b0,
        COUNT = 1'b1
    } state_t;

    state_t state, next_state;
    reg [1:0] byte_counter;  // counts received bytes in COUNT state: 1=start byte, 2=second byte, 3=third byte

    wire start_byte = in[3];

    // Next state and counter logic combinational
    always @(*) begin
        done = 1'b0;
        next_state = state;
        case(state)
            IDLE: begin
                if (start_byte) begin
                    next_state = COUNT;
                end
            end
            COUNT: begin
                if (byte_counter == 2'd3) begin
                    done = 1'b1;
                    next_state = IDLE;
                end
            end
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte_counter <= 2'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            if (state == IDLE) begin
                if (start_byte)
                    byte_counter <= 2'd1; // start counting with first byte
                else
                    byte_counter <= 2'd0;
                done <= 1'b0;
            end else if (state == COUNT) begin
                if (byte_counter < 2'd3) begin
                    byte_counter <= byte_counter + 1'b1;
                    done <= 1'b0;
                end else begin
                    byte_counter <= 2'd0; // reset after done asserted in combinational block
                    done <= 1'b1;         // redundant but safe to assign here
                end
            end else begin
                byte_counter <= 2'd0;
                done <= 1'b0;
            end
        end
    end

endmodule