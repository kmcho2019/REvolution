module TopModule(
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg done_reg;
reg [2:0] state_reg; // 3 states: IDLE (3'b000), START (3'b001), DATA (3'b010), STOP (3'b011)
reg [2:0] state_next;
reg [3:0] counter_reg; // counter for the 8 data bits
reg [3:0] counter_next;

always @(posedge clk) begin
    if (reset) begin
        state_reg <= 3'b000; // IDLE state
        counter_reg <= 4'b0000;
        out_byte_reg <= 8'b00000000;
        done_reg <= 1'b0;
    end else begin
        state_reg <= state_next;
        counter_reg <= counter_next;
        out_byte_reg <= out_byte_reg;
        done_reg <= done_reg;
        
        case (state_reg)
            3'b000: begin // IDLE state
                if (~in) begin // start bit detected
                    state_next <= 3'b001; // transition to START state
                end else begin
                    state_next <= 3'b000; // stay in IDLE state
                end
            end
            3'b001: begin // START state
                state_next <= 3'b010; // transition to DATA state
            end
            3'b010: begin // DATA state
                out_byte_reg <= {out_byte_reg[6:0], in}; // shift in the data bit
                if (counter_reg == 4'b1000) begin // 8 data bits received
                    state_next <= 3'b011; // transition to STOP state
                    counter_next <= 4'b0000;
                end else begin
                    state_next <= 3'b010; // stay in DATA state
                    counter_next <= counter_reg + 1'b1;
                end
            end
            3'b011: begin // STOP state
                if (in) begin // stop bit detected
                    state_next <= 3'b000; // transition to IDLE state
                    done_reg <= 1'b1; // assert done
                end else begin
                    state_next <= 3'b011; // stay in STOP state
                    done_reg <= 1'b0;
                end
            end
            default: begin
                state_next <= 3'b000; // default to IDLE state
            end
        endcase
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule