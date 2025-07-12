module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

logic [2:0] state;
logic [2:0] next_state;
logic [7:0] buffer [2:0];
logic [1:0] buffer_index;

always_comb begin
    next_state = state;
    case(state)
        3'd0: begin // SEARCH
            if(in[3]) begin
                next_state = 3'd1; // BYTE1
                buffer[0] = in;
                buffer_index = 1;
            end
        end
        3'd1: begin // BYTE1
            next_state = 3'd2; // BYTE2
            buffer[1] = in;
            buffer_index = 2;
        end
        3'd2: begin // BYTE2
            next_state = 3'd3; // BYTE3
            buffer[2] = in;
        end
        3'd3: begin // BYTE3
            next_state = 3'd0; // SEARCH
        end
    endcase
    if (in[3] && state != 3'd0) begin
        next_state = 3'd1;
        buffer[0] = in;
        buffer_index = 1;
    end
end

always_ff @(posedge clk) begin
    if(reset) begin
        state <= 3'd0;
        buffer_index <= 0;
        done <= 0;
    end else begin
        state <= next_state;
        if (state == 3'd3) begin
            done <= 1;
        end else begin
            done <= 0;
        end
    end
end

endmodule