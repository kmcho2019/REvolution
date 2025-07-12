module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

// Define the states
enum logic [1:0] {IDLE, BYTE1, BYTE2} state, next_state;

// Define the output logic
assign done = (state == BYTE2);

// Define the next state logic
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
            next_state = IDLE;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

// Define the state register
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        out_bytes <= 24'b0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (in[3] == 1'b1) begin
                    out_bytes[23:16] <= in;
                end
            end
            BYTE1: begin
                out_bytes[15:8] <= in;
            end
            BYTE2: begin
                out_bytes[7:0] <= in;
            end
            default: begin
                // Do nothing
            end
        endcase
    end
end

endmodule