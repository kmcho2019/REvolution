module TopModule(
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg done_reg;
reg [2:0] state_reg; // 0: IDLE, 1: START, 2: DATA, 3: STOP, 4: ERROR
reg [2:0] state_next;
reg [3:0] counter_reg;
reg [3:0] counter_next;
reg out_byte_next [7:0];

always @(*) begin
    // Default values
    state_next = state_reg;
    counter_next = counter_reg;
    out_byte_next = out_byte_reg;
    done_reg = 1'b0;

    case(state_reg)
        0: begin // IDLE
            if (in == 1'b0) begin // Start bit detected
                state_next = 1;
            end else begin
                state_next = 0;
            end
        end
        1: begin // START
            state_next = 2;
            counter_next = 4'b0001;
            out_byte_next[0] = in;
        end
        2: begin // DATA
            counter_next = counter_reg + 1;
            out_byte_next[counter_reg] = in;
            if (counter_reg == 4'b1000) begin // 8 data bits received
                state_next = 3;
            end else begin
                state_next = 2;
            end
        end
        3: begin // STOP
            if (in == 1'b1) begin // Stop bit correct
                state_next = 0;
                done_reg = 1'b1;
            end else begin // Stop bit incorrect
                state_next = 4;
            end
        end
        4: begin // ERROR
            if (in == 1'b1) begin // Stop bit received, back to IDLE
                state_next = 0;
            end else begin
                state_next = 4;
            end
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state_reg <= 0;
        counter_reg <= 0;
        out_byte_reg <= 0;
    end else begin
        state_reg <= state_next;
        counter_reg <= counter_next;
        out_byte_reg <= out_byte_next;
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule