module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

// Define states using an enumeration
enum logic [1:0] {IDLE, BYTE1, BYTE2} state, next_state;

// Combinational logic to determine next state and output values
always_comb begin
    case (state)
        IDLE: begin
            if (in[3] == 1'b1) begin
                next_state = BYTE1;
                out_bytes = {in, 16'b0};
                done = 1'b0;
            end else begin
                next_state = IDLE;
                out_bytes = 24'b0;
                done = 1'b0;
            end
        end
        BYTE1: begin
            next_state = BYTE2;
            out_bytes = {out_bytes[15:0], in};
            done = 1'b0;
        end
        BYTE2: begin
            next_state = IDLE;
            out_bytes = {out_bytes[7:0], in, 8'b0};
            done = 1'b1;
        end
        default: begin
            next_state = IDLE;
            out_bytes = 24'b0;
            done = 1'b0;
        end
    endcase
end

// Sequential logic to update current state and output registers
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        out_bytes <= 24'b0;
        done <= 1'b0;
    end else begin
        state <= next_state;
    end
end

endmodule