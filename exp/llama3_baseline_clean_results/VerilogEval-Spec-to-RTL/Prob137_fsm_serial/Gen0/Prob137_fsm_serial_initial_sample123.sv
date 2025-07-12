module TopModule(
    input  clk,
    input  reset,
    input  in,
    output done
);

reg [2:0] state; // current state: IDLE (0), START (1), DATA (2), STOP (3), DONE (4)
reg [7:0] data; // data bits
reg [3:0] cnt;  // counter for data bits
reg done_reg;   // register for output done

always @(posedge clk) begin
    if (reset) begin // reset to IDLE state
        state <= 0;
        cnt <= 0;
        data <= 0;
        done_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE state
                if (!in) state <= 1; // start bit received
            end
            1: begin // START state
                state <= 2; // transition to DATA state
            end
            2: begin // DATA state
                data[cnt] <= in; // store data bit
                cnt <= cnt + 1;
                if (cnt == 8) state <= 3; // all data bits received, transition to STOP state
            end
            3: begin // STOP state
                if (in) begin // stop bit received
                    state <= 4; // transition to DONE state
                end
            end
            4: begin // DONE state
                done_reg <= 1; // set done flag
                state <= 0; // transition back to IDLE state
            end
            default: state <= 0; // default to IDLE state
        endcase
        if (state == 4) begin // DONE state
            done_reg <= 1;
        end else begin
            done_reg <= 0;
        end
    end
end

assign done = done_reg;

endmodule