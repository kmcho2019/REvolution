module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

// Define states for the FSM
logic [1:0] state;

always_comb begin
    case(state)
        2'd0: begin // SEARCH
            if(in[3]) begin
                state = 2'd1; // Transition to BYTE1
            end
            else begin
                state = 2'd0; // Stay in SEARCH
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
        done <= 0;
    end
    else begin
        done <= (state == 2'd2);
    end
end

endmodule