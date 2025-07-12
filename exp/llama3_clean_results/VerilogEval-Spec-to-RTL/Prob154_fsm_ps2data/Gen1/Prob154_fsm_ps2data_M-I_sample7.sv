module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

// State declaration
enum logic [1:0] {IDLE, BYTE1, BYTE2} state, next_state;

// Internal registers to store the bytes
logic [7:0] byte1, byte2, byte3;

// Internal signals for output ports
logic done_int;
logic [23:0] out_bytes_int;

// Combinational logic to determine the next state
always_comb begin
    next_state = state;
    done_int = 1'b0;
    out_bytes_int = 24'd0;

    case (state)
        IDLE: begin
            if (in[3] == 1'b1) begin
                next_state = BYTE1;
                byte1 = in;
            end
        end
        BYTE1: begin
            next_state = BYTE2;
            byte2 = in;
        end
        BYTE2: begin
            next_state = IDLE;
            byte3 = in;
            out_bytes_int = {byte1, byte2, byte3};
            done_int = 1'b1;
        end
        default: next_state = IDLE;
    endcase

    if (reset == 1'b1) begin
        next_state = IDLE;
    end
end

// Sequential logic to update the state and internal registers
always_ff @(posedge clk) begin
    if (reset == 1'b1) begin
        state <= IDLE;
        byte1 <= 8'd0;
        byte2 <= 8'd0;
        byte3 <= 8'd0;
    end else begin
        state <= next_state;
    end
end

// Assign internal signals to output ports
assign out_bytes = out_bytes_int;
assign done = done_int;

endmodule