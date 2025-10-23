module TopModule(
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

// Define the registers to store the three bytes of the message
reg [7:0] byte1, byte2, byte3;

// Define the output signal
assign done = (state == Byte3);

// Define the FSM
always_comb begin
    case (state)
        Idle: if (in[3]) next_state = Byte1;
             else next_state = Idle;
        Byte1: next_state = Byte2;
        Byte2: next_state = Byte3;
        Byte3: next_state = Idle;
    endcase
end

// Define the sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= Idle;
        byte1 <= 0;
        byte2 <= 0;
        byte3 <= 0;
    end
    else begin
        state <= next_state;
        case (next_state)
            Byte1: byte1 <= in;
            Byte2: byte2 <= in;
            Byte3: byte3 <= in;
        endcase
    end
end

// Define the output
assign out_bytes = {byte1, byte2, byte3};

endmodule