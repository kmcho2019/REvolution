module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

// State encoding
parameter IDLE = 2'b00;
parameter RECEIVE = 2'b01;
parameter STOP = 2'b10;
parameter DONE = 2'b11;

// Current state
reg [1:0] state;

// Next state
reg [1:0] next_state;

// Byte counter
reg [2:0] byte_counter;

// Output byte
reg [7:0] out_byte_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        out_byte_reg <= 8'd0;
        byte_counter <= 3'd0;
    end else begin
        case (state)
            IDLE: begin
                if (!in) begin
                    state <= RECEIVE;
                    byte_counter <= 3'd0;
                end else begin
                    state <= IDLE;
                end
            end
            RECEIVE: begin
                out_byte_reg[byte_counter] <= in;
                byte_counter <= byte_counter + 1;
                if (byte_counter == 8) begin
                    state <= STOP;
                end else begin
                    state <= RECEIVE;
                end
            end
            STOP: begin
                if (in) begin
                    state <= DONE;
                end else begin
                    state <= IDLE;
                end
            end
            DONE: begin
                state <= IDLE;
            end
            default: state <= IDLE;
        endcase
    end
end

always @(posedge clk) begin
    if (state == DONE) begin
        done <= 1'b1;
        out_byte <= out_byte_reg;
    end else begin
        done <= 1'b0;
    end
end

endmodule