module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

logic [1:0] state;

always_ff @(posedge clk) begin
    if(reset) begin
        state <= 2'd0;
        done <= 0;
    end
    else begin
        case(state)
            2'd0: begin // SEARCH
                if(in[3]) begin
                    state <= 2'd1; // Transition to BYTE1
                end
            end
            2'd1: begin // BYTE1
                state <= 2'd2; // Transition to BYTE2
            end
            2'd2: begin // BYTE2
                state <= 2'd0; // Transition back to SEARCH
                done <= 1'b1; // Assert 'done' when transitioning back to SEARCH from BYTE2
            end
        endcase
    end
end

endmodule