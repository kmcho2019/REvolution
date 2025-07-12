module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

// Define the states of the FSM
enum logic [1:0] {
    Idle,
    Byte1,
    Byte2,
    Byte3
} state, next_state;

// Define the registers to store the received bytes
logic [7:0] byte1, byte2, byte3;

// Define the output registers
logic [23:0] out_bytes_reg;

// Define the done signal register
logic done_reg;

always_comb begin
    next_state = state;
    case (state)
        Idle: begin
            if (in[3] == 1) begin
                next_state = Byte1;
            end else begin
                next_state = Idle;
            end
        end
        Byte1: next_state = Byte2;
        Byte2: next_state = Byte3;
        Byte3: next_state = Idle;
    endcase
end

always_ff @(posedge clk) begin
    if (reset) begin
        state <= Idle;
        byte1 <= 8'd0;
        byte2 <= 8'd0;
        byte3 <= 8'd0;
        out_bytes_reg <= 24'd0;
        done_reg <= 1'b0;
    end else begin
        state <= next_state;
        case (state)
            Idle: begin
                if (in[3] == 1) begin
                    byte1 <= in;
                end
            end
            Byte1: begin
                byte2 <= in;
            end
            Byte2: begin
                byte3 <= in;
            end
            Byte3: begin
                out_bytes_reg <= {byte1, byte2, byte3};
                done_reg <= 1'b1;
            end
        endcase
        if (next_state == Idle && next_state != Byte3) begin
            done_reg <= 1'b0;
        end
    end
end

assign out_bytes = out_bytes_reg;
assign done = done_reg;

endmodule