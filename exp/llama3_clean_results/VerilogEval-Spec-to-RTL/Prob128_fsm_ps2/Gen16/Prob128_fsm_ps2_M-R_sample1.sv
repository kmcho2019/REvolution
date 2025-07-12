module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

// Define states for the FSM
enum logic [1:0] {SEARCH, BYTE1, BYTE2} state, next_state;

// Signal to indicate when a message is fully received
logic msg_received;

always_ff @(posedge clk) begin
    if(reset) begin
        state <= SEARCH;
        msg_received <= 0;
        done <= 0;
    end
    else begin
        case(state)
            SEARCH: begin
                if(in[3]) begin
                    state <= BYTE1;
                end
                else begin
                    state <= SEARCH;
                end
                done <= 0;
            end
            BYTE1: begin
                state <= BYTE2;
                done <= 0;
            end
            BYTE2: begin
                state <= SEARCH;
                msg_received <= 1;
                done <= 1;
            end
        endcase
        if (msg_received) begin
            msg_received <= 0;
        end
    end
end

endmodule