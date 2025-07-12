module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

logic [1:0] state;

always_comb begin
    case(state)
        2'd0: begin // SEARCH
            if(in[3]) begin
                state = 2'd1; // BYTE1
            end else begin
                state = 2'd0; // Remain in SEARCH
            end
        end
        2'd1: begin // BYTE1
            state = 2'd2; // Transition to BYTE2
        end
        2'd2: begin // BYTE2
            state = 2'd0; // Transition back to SEARCH
        end
    endcase
end

always_ff @(posedge clk) begin
    if(reset) begin
        state <= 2'd0;
    end else begin
        if (state == 2'd2) begin
            done <= 1'b1;
        end else begin
            done <= 1'b0;
        end
    end
end

endmodule