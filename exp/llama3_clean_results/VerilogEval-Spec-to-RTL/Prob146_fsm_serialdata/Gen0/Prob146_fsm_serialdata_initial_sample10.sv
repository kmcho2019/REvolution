module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] byte;
reg [2:0] state;
reg [3:0] counter;
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        counter <= 0;
        byte <= 8'b0;
        done_reg <= 0;
    end
    else begin
        case (state)
            0: begin // IDLE
                if (~in) begin // start bit detected
                    state <= 1; // START
                end
            end
            1: begin // START
                state <= 2; // RECEIVE
            end
            2: begin // RECEIVE
                byte[7 - counter] <= in;
                if (counter == 7) begin
                    state <= 3; // STOP
                end
                else begin
                    counter <= counter + 1;
                end
            end
            3: begin // STOP
                if (in) begin // stop bit detected
                    done_reg <= 1;
                    state <= 0; // IDLE
                    counter <= 0;
                end
                else begin // stop bit not detected, wait for stop bit
                    state <= 4; // ERROR
                end
            end
            4: begin // ERROR
                if (in) begin // stop bit detected, go back to IDLE
                    state <= 0; // IDLE
                    counter <= 0;
                    byte <= 8'b0;
                end
            end
            default: begin
                state <= 0; // IDLE
            end
        endcase
    end
end

assign out_byte = byte;
assign done = done_reg;

// Make done last for only one clock cycle
always @(posedge clk) begin
    if (reset || ~done_reg) begin
        done_reg <= 0;
    end
end

endmodule