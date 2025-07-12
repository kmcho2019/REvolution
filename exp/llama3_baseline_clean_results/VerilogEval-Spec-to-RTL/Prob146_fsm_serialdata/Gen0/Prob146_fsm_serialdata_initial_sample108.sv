module TopModule(
    input           clk,
    input           in,
    input           reset,
    output  [7:0]   out_byte,
    output          done
);

enum logic [2:0] {IDLE, START, RECEIVE, STOP, DONE} state, next_state;

logic [2:0] bit_count;
logic [7:0] byte;

always_comb begin
    next_state = state;
    done = 1'b0;
    case(state)
        IDLE: begin
            if(in == 1'b0) next_state = START;
        end
        START: next_state = RECEIVE;
        RECEIVE: begin
            if(bit_count == 3'd7) next_state = STOP;
            else next_state = RECEIVE;
        end
        STOP: begin
            if(in == 1'b1) next_state = DONE;
            else next_state = IDLE; // Invalid stop bit, go back to IDLE
        end
        DONE: begin
            next_state = IDLE;
            done = 1'b1;
        end
    endcase
end

always_ff @(posedge clk) begin
    if(reset) begin
        state <= IDLE;
        bit_count <= 3'd0;
        byte <= 8'd0;
    end else begin
        state <= next_state;
        case(state)
            START: bit_count <= 3'd0;
            RECEIVE: begin
                byte[bit_count] <= in;
                bit_count <= bit_count + 1;
            end
            DONE: out_byte <= byte;
        endcase
    end
end

endmodule