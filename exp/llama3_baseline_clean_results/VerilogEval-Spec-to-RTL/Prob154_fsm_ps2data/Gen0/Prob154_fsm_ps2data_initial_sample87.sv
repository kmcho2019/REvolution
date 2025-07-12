module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

// State machine states
localparam IDLE = 2'b00;
localparam BYTE1 = 2'b01;
localparam BYTE2 = 2'b10;
localparam DONE = 2'b11;

// Registers
reg [1:0] state;
reg [1:0] next_state;
reg [7:0] byte1;
reg [7:0] byte2;
reg [7:0] byte3;
reg [23:0] out_bytes_reg;

// Combinational logic for next state
always @(*) begin
    case (state)
        IDLE: begin
            if (in[3] == 1) begin
                next_state = BYTE1;
            end else begin
                next_state = IDLE;
            end
        end
        BYTE1: begin
            next_state = BYTE2;
        end
        BYTE2: begin
            next_state = DONE;
        end
        DONE: begin
            next_state = IDLE;
        end
    endcase
end

// Sequential logic for state and registers
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        byte1 <= 8'b0;
        byte2 <= 8'b0;
        byte3 <= 8'b0;
        out_bytes_reg <= 24'b0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (in[3] == 1) begin
                    byte1 <= in;
                end
            end
            BYTE1: begin
                byte2 <= in;
            end
            BYTE2: begin
                byte3 <= in;
            end
            DONE: begin
                out_bytes_reg <= {byte1, byte2, byte3};
            end
        endcase
    end
end

// Output logic
assign out_bytes = out_bytes_reg;
assign done = (state == DONE);

endmodule