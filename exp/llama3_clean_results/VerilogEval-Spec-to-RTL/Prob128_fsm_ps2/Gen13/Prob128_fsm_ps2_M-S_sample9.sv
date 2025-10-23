module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

logic [1:0] state;
logic [1:0] next_state;
logic [1:0] byte_count;
logic [1:0] next_byte_count;

always_comb begin
    next_state = state;
    next_byte_count = byte_count;
    case(state)
        2'd0: begin // SEARCH
            if(in[3]) begin
                next_state = 2'd1; // MESSAGE
                next_byte_count = 2'd1;
            end
        end
        2'd1: begin // MESSAGE
            next_byte_count = byte_count + 1;
            if (byte_count == 2'd2) begin
                next_state = 2'd0; // SEARCH
            end
        end
    endcase
end

always_ff @(posedge clk) begin
    if(reset) begin
        state <= 2'd0;
        byte_count <= 2'd0;
        done <= 0;
    end else begin
        state <= next_state;
        byte_count <= next_byte_count;
        if (next_state == 2'd0 && state == 2'd1) begin
            done <= 1;
        end else begin
            done <= 0;
        end
    end
end

endmodule