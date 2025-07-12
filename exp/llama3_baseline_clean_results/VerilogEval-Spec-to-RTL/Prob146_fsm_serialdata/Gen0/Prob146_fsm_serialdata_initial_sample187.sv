module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg done_reg;

reg [2:0] state_reg; // 0: IDLE, 1: START, 2: DATA, 3: STOP
reg [2:0] state_next;

reg [2:0] bit_counter_reg; // counter for data bits

always @(*) begin
    case(state_reg)
        3'b000: begin // IDLE
            if (in == 0) begin // start bit detected
                state_next = 3'b001; // go to START state
            end else begin
                state_next = 3'b000; // stay in IDLE state
            end
        end
        3'b001: begin // START
            state_next = 3'b010; // go to DATA state
        end
        3'b010: begin // DATA
            if (bit_counter_reg == 3'b1000) begin // all data bits collected
                state_next = 3'b011; // go to STOP state
            end else begin
                state_next = 3'b010; // stay in DATA state
            end
        end
        3'b011: begin // STOP
            if (in == 1) begin // stop bit detected
                state_next = 3'b000; // go to IDLE state
                done_reg = 1'b1; // assert done signal
            end else begin
                state_next = 3'b011; // stay in STOP state
            end
        end
        default: state_next = 3'b000; // default to IDLE state
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state_reg <= 3'b000; // reset to IDLE state
        bit_counter_reg <= 3'b000; // reset bit counter
        done_reg <= 1'b0; // deassert done signal
    end else begin
        state_reg <= state_next;
        if (state_reg == 3'b010) begin // in DATA state
            out_byte_reg[bit_counter_reg] <= in; // store data bit
            bit_counter_reg <= bit_counter_reg + 1'b1; // increment bit counter
        end else if (state_reg == 3'b011) begin // in STOP state
            if (done_reg) begin
                bit_counter_reg <= 3'b000; // reset bit counter
            end
        end else begin
            bit_counter_reg <= 3'b000; // reset bit counter
        end
        if (state_reg == 3'b011 && done_reg) begin
            done_reg <= 1'b0; // deassert done signal
        end
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule