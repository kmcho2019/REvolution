module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output          done
);

logic [1:0] state;
logic [1:0] next_state;
logic [7:0] byte_buffer;
logic [1:0] byte_counter;
logic [1:0] next_byte_counter;

always_comb begin
    next_state = state;
    next_byte_counter = byte_counter;
    case(state)
        0: begin // IDLE
            if(in[3]) begin
                next_state = 1; // BYTE1
                next_byte_counter = 1;
            end
        end
        1: begin // BYTE1
            next_state = 2; // BYTE2
            next_byte_counter = 2;
        end
        2: begin // BYTE2
            next_state = 3; // BYTE3
            next_byte_counter = 3;
        end
        3: begin // BYTE3
            next_state = 0; // IDLE
            next_byte_counter = 0;
        end
    endcase
    if (in[3] && state != 0) begin
        next_state = 1;
        next_byte_counter = 1;
    end
end

always_ff @(posedge clk) begin
    if(reset) begin
        state <= 0;
        byte_counter <= 0;
        done <= 0;
    end else begin
        state <= next_state;
        byte_counter <= next_byte_counter;
        if (byte_counter == 3) begin
            done <= 1;
        end else begin
            done <= 0;
        end
    end
end

endmodule