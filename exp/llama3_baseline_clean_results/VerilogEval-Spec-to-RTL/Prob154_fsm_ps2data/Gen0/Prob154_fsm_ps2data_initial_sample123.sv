module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

// Define states
enum logic [1:0] {IDLE, BYTE1, BYTE2, BYTE3} state, next_state;

// Internal signals
logic [7:0] byte1, byte2, byte3;

// State register
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always_comb begin
    case (state)
        IDLE: begin
            if (in[3] == 1'b1) begin
                next_state = BYTE1;
            end else begin
                next_state = IDLE;
            end
        end
        BYTE1: begin
            next_state = BYTE2;
        end
        BYTE2: begin
            next_state = BYTE3;
        end
        BYTE3: begin
            next_state = IDLE;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

// Datapath logic
always_ff @(posedge clk) begin
    case (state)
        IDLE: begin
            // Do nothing
        end
        BYTE1: begin
            byte1 <= in;
        end
        BYTE2: begin
            byte2 <= in;
        end
        BYTE3: begin
            byte3 <= in;
        end
        default: begin
            // Do nothing
        end
    endcase
end

// Output logic
always_comb begin
    case (state)
        IDLE: begin
            out_bytes = 'x;
            done = 1'b0;
        end
        BYTE1: begin
            out_bytes = 'x;
            done = 1'b0;
        end
        BYTE2: begin
            out_bytes = 'x;
            done = 1'b0;
        end
        BYTE3: begin
            out_bytes = {byte1, byte2, byte3};
            done = 1'b1;
        end
        default: begin
            out_bytes = 'x;
            done = 1'b0;
        end
    endcase
end

endmodule