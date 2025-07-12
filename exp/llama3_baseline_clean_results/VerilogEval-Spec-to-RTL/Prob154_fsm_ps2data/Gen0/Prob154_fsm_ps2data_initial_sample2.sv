module TopModule(
    input  clk,
    input  reset,
    input  [7:0] in,
    output [23:0] out_bytes,
    output done
);

// Define the states
parameter IDLE = 2'b00;
parameter BYTE1 = 2'b01;
parameter BYTE2 = 2'b10;
parameter BYTE3 = 2'b11;

// Define the state register
reg [1:0] state;
reg [1:0] next_state;

// Define the registers to store the bytes
reg [7:0] byte1;
reg [7:0] byte2;
reg [7:0] byte3;

// Define the out_bytes signal
assign out_bytes = {byte1, byte2, byte3};

// Define the done signal
assign done = (state == BYTE3);

// FSM transitions
always @(*) begin
    case(state)
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

// Sequential logic
always @(posedge clk) begin
    if (reset == 1'b1) begin
        state <= IDLE;
        byte1 <= 8'b0;
        byte2 <= 8'b0;
        byte3 <= 8'b0;
    end else begin
        state <= next_state;
        case(next_state)
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
end

endmodule