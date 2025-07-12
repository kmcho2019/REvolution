module TopModule (
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

// Define the states
enum logic [2:0] {
    IDLE,
    START,
    DATA,
    STOP
} state, next_state;

// Define the shift register to store the received data bits
logic [7:0] data_reg;
logic [2:0] data_count;

// Define the output register
logic [7:0] out_reg;

// Define the done signal
logic done_reg;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        data_reg <= 8'b0;
        data_count <= 3'b0;
        out_reg <= 8'b0;
        done_reg <= 1'b0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (in == 1'b0) begin
                    next_state <= START;
                end else begin
                    next_state <= IDLE;
                end
            end
            START: begin
                data_reg[0] <= in;
                next_state <= DATA;
                data_count <= 3'b1;
            end
            DATA: begin
                data_reg <= {data_reg[6:0], in};
                data_count <= data_count + 1'b1;
                if (data_count == 3'b8) begin
                    next_state <= STOP;
                end else begin
                    next_state <= DATA;
                end
            end
            STOP: begin
                if (in == 1'b1) begin
                    out_reg <= data_reg;
                    done_reg <= 1'b1;
                    next_state <= IDLE;
                end else begin
                    next_state <= IDLE;
                end
            end
            default: next_state <= IDLE;
        endcase
    end
end

assign out_byte = out_reg;
assign done = done_reg;
endmodule