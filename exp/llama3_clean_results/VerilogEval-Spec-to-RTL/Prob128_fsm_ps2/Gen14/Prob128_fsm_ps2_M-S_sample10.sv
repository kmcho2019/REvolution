module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

logic [1:0] state;
logic [1:0] next_state;

always_comb begin
    next_state = state;
    case(state)
        2'd0: begin // SEARCH
            if(in[3]) begin
                next_state = 2'd1; // BYTE1
            end
        end
        2'd1: begin // BYTE1
            next_state = 2'd2; // BYTE2
        end
        2'd2: begin // BYTE2
            next_state = 2'd0; // SEARCH
        end
    endcase
end

always_ff @(posedge clk) begin
    if(reset) begin
        state <= 2'd0;
        done <= 0;
    end else begin
        state <= next_state;
        if (next_state == 2'd0 && state == 2'd2) begin
            done <= 1;
        end else begin
            done <= 0;
        end
    end
end

endmodule